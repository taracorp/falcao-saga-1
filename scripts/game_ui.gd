extends Control

@onready var moves_label = $TopBar/Moves
@onready var score_label = $TopBar/Score
@onready var board = $Board

func _ready() -> void:
	$TopBar/BtnBack.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main.tscn"))
	$BottomBar/BtnHammer.pressed.connect(func(): _buy("hammer"))
	$BottomBar/BtnBomb.pressed.connect(func(): _buy("bomb"))
	$BottomBar/BtnMoves.pressed.connect(func(): _buy("moves"))
	board.score_changed.connect(func(s): score_label.text = "Score: %d" % s)
	board.moves_changed.connect(func(m):
		moves_label.text = "Moves: %d" % m
		if m <= 3: moves_label.add_theme_color_override("font_color", Color.RED)
	)
	board.level_complete.connect(_on_level_complete)
	board.combo_made.connect(_on_combo)
	board.setup_level("score", 1000, 20)

func _buy(type: String) -> void:
	match type:
		"hammer": if GameManager.spend_coins(150): board.use_hammer(Vector2i(3, 3))
		"bomb": if GameManager.spend_coins(300): board.use_bomb(Vector2i(3, 3))
		"moves": if GameManager.spend_coins(200):
			board._moves_remaining += 5
			board.moves_changed.emit(board._moves_remaining)

func _on_combo(combo: String) -> void:
	GameManager.on_combo(combo)
	var txt = ""
	match combo:
		"4_row": txt = "Tendangan Falcao!"
		"5_row": txt = "GOL SPEKTAKULER!"
		"L_shape": txt = "Bom Suporter!"
		"T_shape": txt = "Yel-Yel BCS!"
	var l = Label.new()
	l.text = txt
	l.add_theme_font_size_override("font_size", 28)
	l.add_theme_color_override("font_color", Color(0.973, 0.996, 0.024, 1.0))
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.position = Vector2(160, 500)
	l.size = Vector2(400, 50)
	$Canvas/UI.add_child(l)
	var t = create_tween().set_parallel(true)
	t.tween_property(l, "position:y", 440, 0.6)
	t.tween_property(l, "modulate:a", 0.0, 0.6)
	t.tween_callback(l.queue_free)

func _on_level_complete(stars: int) -> void:
	GameManager.on_level_complete(stars)
	var p = AcceptDialog.new()
	p.title = "Level Complete!"
	p.dialog_text = "%s\nScore: %d" % ["⭐".repeat(stars), board._score]
	p.confirmed.connect(func(): get_tree().change_scene_to_file("res://scenes/main.tscn"))
	$Canvas/UI.add_child(p)
	p.popup_centered()
