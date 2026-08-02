extends Control
## Authentication screen (login/signup)

@onready var username_input = $FormContainer/UsernameInput
@onready var email_input = $FormContainer/EmailInput
@onready var password_input = $FormContainer/PasswordInput
@onready var error_label = $FormContainer/ErrorLabel
@onready var loading = $LoadingIndicator

func _ready() -> void:
	$FormContainer/ButtonContainer/SignInButton.pressed.connect(_on_sign_in)
	$FormContainer/ButtonContainer/SignUpButton.pressed.connect(_on_sign_up)
	$FormContainer/SkipButton.pressed.connect(_on_skip)

	SupabaseClient.auth_success.connect(_on_auth_success)
	SupabaseClient.auth_error.connect(_on_auth_error)

	# Auto-skip if already logged in locally
	if GameManager.username != "":
		go_to_main()

func _on_sign_in() -> void:
	var email = email_input.text.strip_edges()
	var password = password_input.text

	if email == "" or password == "":
		_show_error("Email and password required")
		return

	_show_loading(true)
	SupabaseClient.sign_in(email, password)

func _on_sign_up() -> void:
	var username = username_input.text.strip_edges()
	var email = email_input.text.strip_edges()
	var password = password_input.text

	if username == "" or email == "" or password == "":
		_show_error("All fields required")
		return
	if password.length() < 6:
		_show_error("Password must be at least 6 characters")
		return

	_show_loading(true)
	SupabaseClient.sign_up(email, password, username)

func _on_skip() -> void:
	GameManager.username = "Player_" + str(randi() % 10000)
	go_to_main()

func _on_auth_success(user_data: Dictionary) -> void:
	_show_loading(false)
	var username = user_data.get("user_metadata", {}).get("username", user_data.get("email", "Player"))
	GameManager.username = username
	GameManager.save_local_data()

	# Try to create profile or fetch existing
	SupabaseClient.create_profile(username)
	go_to_main()

func _on_auth_error(message: String) -> void:
	_show_loading(false)
	_show_error(message)

func _show_error(msg: String) -> void:
	error_label.text = msg
	var tween = create_tween()
	tween.tween_property(error_label, "modulate:a", 1.0, 0.1)
	tween.tween_interval(3.0)
	tween.tween_property(error_label, "modulate:a", 0.0, 0.5)

func _show_loading(show: bool) -> void:
	loading.visible = show

func go_to_main() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
