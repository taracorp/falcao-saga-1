extends Control
## Game scene UI controller

@onready var moves_label = $TopBar/MovesLabel
@onready var score_label = $TopBar/ScoreLabel
@onready var target_label = $TopBar/TargetLabel
@onready var board = $BoardNode

func _ready() -> void:
	_connect_signals()
	board.setup_level("score", 1000, 20)

func _connect_signals() -> void:
	$TopBar/BackButton.pressed.connect(_on_back_pressed)
	board.score_changed.connect(_on_score_changed)
	board.moves_changed.connect(_on_moves_changed)
	board.level_complete.connect(_on_level_complete)
	board.combo_made.connect(_on_combo)

	$HUD/HammerBtn.pressed.connect(func(): _use_powerup("hammer"))
	$HUD/BombBtn.pressed.connect(func(): _use_powerup("bomb"))
	$HUD/MovesBtn.pressed.connect(func(): _use_powerup("moves"))

func _on_score_changed(score: int) -> void:
	score_label.text = "Score: %d" % score

func _on_moves_changed(remaining: int) -> void:
	moves_label.text = "Moves: %d" % remaining
	if remaining <= 3:
		moves_label.add_theme_color_override("font_color", Color.RED)

func _on_combo(combo_type: String) -> void:
	GameManager.on_combo(combo_type)
	var text = ""
	match combo_type:
		"4_row": text = "🔥 Tendangan Falcao!"
		"5_row": text = "⚽ GOL SPEKTAKULER!"
		"L_shape": text = "💥 Bom Suporter!"
		"T_shape": text = "📣 Yel-Yel BCS!"
	_flash_text(text)

func _on_level_complete(stars: int) -> void:
	GameManager.on_level_complete(stars)
	var popup = AcceptDialog.new()
	popup.title = "Level Complete!"
	var star_str = "⭐".repeat(stars)
	popup.dialog_text = "%s\n\nScore: %d\nCoins earned: %d\nXP earned: %d" % [star_str, board._score, Config.COINS_PER_LEVEL, Config.XP_PER_LEVEL]
	popup.confirmed.connect(func(): get_tree().change_scene_to_file("res://scenes/main.tscn"))
	add_child(popup)
	popup.popup_centered()

func _use_powerup(type: String) -> void:
	match type:
		"hammer":
			if GameManager.spend_coins(150):
				board.use_hammer(Vector2i(3, 3))
		"bomb":
			if GameManager.spend_coins(300):
				board.use_bomb(Vector2i(3, 3))
		"moves":
			if GameManager.spend_coins(200):
				board._moves_remaining += 5
				board.moves_changed.emit(board._moves_remaining)

func _flash_text(text: String) -> void:
	var label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 28)
	label.add_theme_color_override("font_color", Color(1.0, 0.843, 0.0, 1.0))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.position = Vector2(360, 600) - label.size / 2
	add_child(label)

	var tween = create_tween()
	tween.tween_property(label, "position:y", 500, 0.5)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 0.5)
	tween.tween_callback(label.queue_free)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
