extends Node2D

@onready var email_input = $UI/Email
@onready var password_input = $UI/Password
@onready var error_label = $UI/Error

func _ready() -> void:
	$UI/BtnSignIn.pressed.connect(_on_sign_in)
	$UI/BtnSkip.pressed.connect(_on_skip)
	SupabaseClient.auth_success.connect(_on_auth_success)
	SupabaseClient.auth_error.connect(_on_auth_error)
	if GameManager.username != "":
		get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_sign_in() -> void:
	var email = email_input.text.strip_edges()
	var password = password_input.text
	if email == "" or password == "":
		_show_error("Email and password required"); return
	$UI/LoadingOverlay.visible = true
	SupabaseClient.sign_in(email, password)

func _on_skip() -> void:
	GameManager.username = "Player_" + str(randi() % 10000)
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_auth_success(user_data: Dictionary) -> void:
	$UI/LoadingOverlay.visible = false
	GameManager.username = user_data.get("user_metadata", {}).get("username", user_data.get("email", "Player"))
	GameManager.save_local_data()
	SupabaseClient.create_profile(GameManager.username)
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_auth_error(msg: String) -> void:
	$UI/LoadingOverlay.visible = false
	_show_error(msg)

func _show_error(msg: String) -> void:
	error_label.text = msg
	error_label.modulate.a = 1.0
	var t = create_tween()
	t.tween_interval(3.0)
	t.tween_property(error_label, "modulate:a", 0.0, 0.5)
