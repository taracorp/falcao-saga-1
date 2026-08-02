extends Node
## HTTP Client for Supabase REST API communication

signal auth_success(user_data: Dictionary)
signal auth_error(message: String)
signal data_loaded(table: String, data: Array)
signal data_error(message: String)

var _access_token: String = ""
var _refresh_token: String = ""
var _user_id: String = ""
var _http: HTTPRequest

func _ready() -> void:
	_http = HTTPRequest.new()
	add_child(_http)

func get_headers() -> PackedStringArray:
	var headers = [
		"apikey: " + Config.SUPABASE_ANON_KEY,
		"Authorization: Bearer " + _access_token,
		"Content-Type: application/json",
		"Prefer: return=representation"
	]
	return headers

func get_headers_anon() -> PackedStringArray:
	return [
		"apikey: " + Config.SUPABASE_ANON_KEY,
		"Content-Type: application/json"
	]

# ─── Auth ──────────────────────────────────────────────

func sign_up(email: String, password: String, username: String) -> void:
	var body = JSON.stringify({
		"email": email,
		"password": password,
		"options": { "data": { "username": username } }
	})
	var url = Config.SUPABASE_URL + "/auth/v1/signup"
	var err = _http.request(url, get_headers_anon(), HTTPClient.METHOD_POST, body)
	if err != OK: auth_error.emit("Signup request failed")

func sign_in(email: String, password: String) -> void:
	var body = JSON.stringify({ "email": email, "password": password })
	var url = Config.SUPABASE_URL + "/auth/v1/token?grant_type=password"
	var err = _http.request(url, get_headers_anon(), HTTPClient.METHOD_POST, body)
	if err != OK: auth_error.emit("Login request failed")

func sign_out() -> void:
	_access_token = ""
	_refresh_token = ""
	_user_id = ""

func is_logged_in() -> bool:
	return _access_token != ""

func get_user_id() -> String:
	return _user_id

# ─── CRUD Operations ───────────────────────────────────

func fetch_data(table: String, query: String = "", callback: Callable = Callable()) -> void:
	var url = Config.SUPABASE_URL + "/rest/v1/" + table
	if query != "": url += "?" + query
	var err = _http.request(url, get_headers(), HTTPClient.METHOD_GET)
	if err == OK:
		if callback.is_valid():
			await _http.request_completed
			_on_fetch_complete(callback)

func insert_data(table: String, data: Dictionary) -> void:
	var url = Config.SUPABASE_URL + "/rest/v1/" + table
	var body = JSON.stringify(data)
	_http.request(url, get_headers(), HTTPClient.METHOD_POST, body)

func update_data(table: String, query: String, data: Dictionary) -> void:
	var url = Config.SUPABASE_URL + "/rest/v1/" + table + "?" + query
	var body = JSON.stringify(data)
	_http.request(url, get_headers(), HTTPClient.METHOD_PATCH, body)

# ─── Profile ──────────────────────────────────────────

func create_profile(username: String) -> void:
	if _user_id == "": return
	var data = {
		"id": _user_id,
		"username": username,
		"total_xp": 0,
		"total_coins": Config.INITIAL_COINS,
		"total_rpp": 0,
		"current_season": 1
	}
	insert_data("fs_profiles", data)

func fetch_profile() -> void:
	fetch_data("fs_profiles", "id=eq." + _user_id)

func add_coins(amount: int, source: String) -> void:
	var data = { "profile_id": _user_id, "type": "coin_earn", "amount": amount, "source": source }
	insert_data("fs_point_transactions", data)

func add_xp(amount: int, source: String) -> void:
	var data = { "profile_id": _user_id, "type": "xp_earn", "amount": amount, "source": source }
	insert_data("fs_point_transactions", data)

func add_rpp(amount: int, source: String) -> void:
	var data = { "profile_id": _user_id, "type": "rpp_earn", "amount": amount, "source": source }
	insert_data("fs_point_transactions", data)

# ─── Cards ────────────────────────────────────────────

func add_card(card_id: int, is_foil: bool = false) -> void:
	var data = {
		"profile_id": _user_id,
		"card_id": card_id,
		"quantity": 1,
		"is_foil": is_foil
	}
	insert_data("fs_player_cards", data)

func fetch_cards() -> void:
	fetch_data("fs_player_cards", "profile_id=eq." + _user_id + "&order=card_id.asc")

# ─── Jerseys ──────────────────────────────────────────

func add_jersey(jersey_id: int) -> void:
	var data = { "profile_id": _user_id, "jersey_id": jersey_id }
	insert_data("fs_jerseys", data)

func fetch_jerseys() -> void:
	fetch_data("fs_jerseys", "profile_id=eq." + _user_id)

# ─── Leaderboard ──────────────────────────────────────

func fetch_leaderboard(limit: int = 100) -> void:
	fetch_data("fs_leaderboard", "order=xp.desc&limit=" + str(limit))

func submit_leaderboard(xp: int, cards_collected: int) -> void:
	var data = {
		"profile_id": _user_id,
		"username": "",
		"xp": xp,
		"cards_collected": cards_collected,
		"week_start": Time.get_datetime_string_from_system().split("T")[0]
	}
	insert_data("fs_leaderboard", data)

# ─── Rewards ──────────────────────────────────────────

func fetch_rewards() -> void:
	fetch_data("fs_reward_catalog", "is_active=eq.true&order=rpp_cost.asc")

func redeem_reward(reward_id: int, shipping_info: Dictionary = {}) -> void:
	var data = {
		"profile_id": _user_id,
		"reward_id": reward_id,
		"shipping_info": JSON.stringify(shipping_info)
	}
	insert_data("fs_redemptions", data)

# ─── HTTP Response Handler ────────────────────────────

func _on_fetch_complete(callback: Callable) -> void:
	if _http.get_response_code() >= 200 and _http.get_response_code() < 300:
		var body = _http.get_response_body_as_string()
		var json = JSON.parse_string(body)
		callback.call(json)
	else:
		data_error.emit("HTTP " + str(_http.get_response_code()))

func _on_http_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var body_str = body.get_string_from_utf8()
	var json = JSON.parse_string(body_str)

	if response_code >= 200 and response_code < 300:
		var url = _http.get_http_client_status()

		if "/auth/v1/" in url:
			if json and json.has("access_token"):
				_access_token = json["access_token"]
				_refresh_token = json.get("refresh_token", "")
				_user_id = json.get("user", {}).get("id", "")
				auth_success.emit(json.get("user", {}))
			else:
				auth_error.emit("Invalid auth response")

		elif "/rest/v1/" in url:
			data_loaded.emit(_get_table_from_url(url), json if json is Array else [json])
	else:
		var msg = json.get("message", "Unknown error") if json else "Request failed"
		data_error.emit(msg)

func _get_table_from_url(url: String) -> String:
	var parts = url.split("/rest/v1/")
	if parts.size() > 1:
		return parts[1].split("?")[0]
	return "unknown"
