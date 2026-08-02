extends Node
## Central game state manager (Autoload singleton)

signal coins_changed(new_amount: int)
signal xp_changed(new_amount: int)
signal rpp_changed(new_amount: int)
signal lives_changed(new_amount: int)
signal card_acquired(card_id: int, rarity: int)
signal season_unlocked(season_id: int)

# Player state
var username: String = ""
var coins: int = 0
var xp: int = 0
var rpp: int = 0
var lives: int = Config.MAX_LIVES
var current_season: int = 1
var current_level: int = 1
var cards: Dictionary = {}       # card_id -> {quantity, is_foil}
var jerseys: Array[int] = []
var unlocked_seasons: Array[int] = [1]
var settings: Dictionary = {
	"sound_enabled": true,
	"music_enabled": true,
	"vibration_enabled": true,
}

# Level state
var level_score: int = 0
var level_moves_used: int = 0
var level_max_moves: int = 20

func _ready() -> void:
	_load_local_data()

# ─── Local Save/Load ──────────────────────────────────

func _load_local_data() -> void:
	var file = FileAccess.open("user://save.json", FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		if data:
			username = data.get("username", "")
			lives = data.get("lives", Config.MAX_LIVES)
			current_season = data.get("current_season", 1)
			current_level = data.get("current_level", 1)
			cards = data.get("cards", {})
			jerseys = data.get("jerseys", [])
			unlocked_seasons = data.get("unlocked_seasons", [1])
			settings = data.get("settings", settings)
		file.close()

func save_local_data() -> void:
	var data = {
		"username": username,
		"lives": lives,
		"current_season": current_season,
		"current_level": current_level,
		"cards": cards,
		"jerseys": jerseys,
		"unlocked_seasons": unlocked_seasons,
		"settings": settings,
	}
	var file = FileAccess.open("user://save.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	file.close()

# ─── Currency ─────────────────────────────────────────

func add_coins(amount: int) -> void:
	coins += amount
	coins_changed.emit(coins)
	if SupabaseClient.is_logged_in():
		SupabaseClient.add_coins(amount, "gameplay")

func spend_coins(amount: int) -> bool:
	if coins >= amount:
		coins -= amount
		coins_changed.emit(coins)
		return true
	return false

func add_xp(amount: int) -> void:
	xp += amount
	xp_changed.emit(xp)

func add_rpp(amount: int) -> void:
	rpp += amount
	rpp_changed.emit(rpp)

func spend_rpp(amount: int) -> bool:
	if rpp >= amount:
		rpp -= amount
		rpp_changed.emit(rpp)
		return true
	return false

# ─── Lives ────────────────────────────────────────────

func use_life() -> bool:
	if lives > 0:
		lives -= 1
		lives_changed.emit(lives)
		save_local_data()
		return true
	return false

func recover_life() -> void:
	if lives < Config.MAX_LIVES:
		lives += 1
		lives_changed.emit(lives)
		save_local_data()

func refill_lives() -> void:
	lives = Config.MAX_LIVES
	lives_changed.emit(lives)
	save_local_data()

# ─── Cards ────────────────────────────────────────────

func has_card(card_id: int) -> bool:
	return cards.has(str(card_id))

func get_card_count() -> int:
	return cards.size()

func add_card(card_id: int, rarity: int, is_foil: bool = false) -> void:
	var key = str(card_id)
	if cards.has(key):
		cards[key]["quantity"] += 1
		add_coins(_get_duplicate_coins(rarity))
	else:
		cards[key] = { "quantity": 1, "is_foil": is_foil }
		add_xp(Config.XP_NEW_CARD)
	card_acquired.emit(card_id, rarity)
	save_local_data()

func _get_duplicate_coins(rarity: int) -> int:
	match rarity:
		Config.RARITY_RARE: return Config.COINS_DUPLICATE_RARE
		Config.RARITY_EPIC: return Config.COINS_DUPLICATE_EPIC
		Config.RARITY_LEGENDARY: return Config.COINS_DUPLICATE_LEGENDARY
		Config.RARITY_MYTHIC: return Config.COINS_DUPLICATE_MYTHIC
		_: return Config.COINS_DUPLICATE_COMMON

func get_season_completion(season_id: int) -> float:
	var total = Config.get_season_config()[season_id - 1]["count"]
	var owned = 0
	for card_id in cards:
		var card_season = ((int(card_id) - 1) / 20) + 1
		if card_season == season_id:
			owned += 1
	return float(owned) / float(total) if total > 0 else 0.0

# ─── Seasons ──────────────────────────────────────────

func unlock_season(season_id: int) -> void:
	if not unlocked_seasons.has(season_id):
		unlocked_seasons.append(season_id)
		season_unlocked.emit(season_id)
		save_local_data()

func try_unlock_next_season() -> void:
	var completion = get_season_completion(current_season)
	if completion >= 0.5 and not unlocked_seasons.has(current_season + 1):
		unlock_season(current_season + 1)

# ─── Jersey ────────────────────────────────────────────

func has_jersey(jersey_id: int) -> bool:
	return jerseys.has(jersey_id)

func add_jersey(jersey_id: int) -> void:
	if not jerseys.has(jersey_id):
		jerseys.append(jersey_id)
		save_local_data()
		if SupabaseClient.is_logged_in():
			SupabaseClient.add_jersey(jersey_id)

# ─── Level Rewards ────────────────────────────────────

func on_level_complete(stars: int) -> void:
	var xp_earned = Config.XP_PER_LEVEL
	var coins_earned = Config.COINS_PER_LEVEL

	if stars == 3:
		xp_earned += Config.XP_BONUS_3STAR
		coins_earned += Config.COINS_BONUS_3STAR

	add_xp(xp_earned)
	add_coins(coins_earned)

	# Check win streak
	current_level += 1
	if current_level % 10 == 0:
		add_rpp(Config.RPP_WINSTREAK_10)

	try_unlock_next_season()
	save_local_data()

# ─── Combo Rewards ────────────────────────────────────

func on_combo(combo_type: String) -> void:
	match combo_type:
		"4_row":
			add_xp(Config.XP_COMBO_4)
		"5_row":
			add_xp(Config.XP_COMBO_5)
			add_coins(50)
		"L_shape":
			add_xp(Config.XP_COMBO_5 + 10)
			add_coins(75)
		"T_shape":
			add_xp(Config.XP_COMBO_5 + 10)
			add_coins(75)
