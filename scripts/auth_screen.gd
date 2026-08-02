extends Control

@onready var username_input = $Center/VBox/Username
@onready var email_input = $Center/VBox/Email
@onready var password_input = $Center/VBox/Password
@onready var error_label = $Center/VBox/Error

func _ready() -> void:
	$Center/VBox/BtnSignIn.pressed.connect(func(): _submit(false))
	$Center/VBox/BtnSignUp.pressed.connect(func(): _submit(true))
	$Center/VBox/BtnSkip.pressed.connect(func():
		GameManager.username = "Player_" + str(randi() % 10000)
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	)
	SupabaseClient.auth_success.connect(_on_auth_success)
	SupabaseClient.auth_error.connect(_on_auth_error)
	if GameManager.username != "":
		get_tree().change_scene_to_file("res://scenes/main.tscn")

func _submit(is_signup: bool) -> void:
	var email = email_input.text.strip_edges()
	var password = password_input.text
	if email == "" or password == "":
		_show_error("Email and password required"); return
	if is_signup:
		var username = username_input.text.strip_edges()
		if username == "": _show_error("Username required"); return
		if password.length() < 6: _show_error("Password min 6 characters"); return
		$LoadingOverlay.visible = true
		SupabaseClient.sign_up(email, password, username)
	else:
		$LoadingOverlay.visible = true
		SupabaseClient.sign_in(email, password)

func _on_auth_success(user_data: Dictionary) -> void:
	$LoadingOverlay.visible = false
	GameManager.username = user_data.get("user_metadata", {}).get("username", user_data.get("email", "Player"))
	GameManager.save_local_data()
	SupabaseClient.create_profile(GameManager.username)
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_auth_error(msg: String) -> void:
	$LoadingOverlay.visible = false
	_show_error(msg)

func _show_error(msg: String) -> void:
	error_label.text = msg
	error_label.modulate.a = 1.0
	var t = create_tween()
	t.tween_interval(3.0)
	t.tween_property(error_label, "modulate:a", 0.0, 0.5)
