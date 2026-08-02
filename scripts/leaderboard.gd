extends Control

func _ready() -> void:
	$TopBar/BackButton.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main.tscn"))
	_setup_tabs()
	_load_leaderboard()

func _setup_tabs() -> void:
	$MainVBox/TabBar.add_tab("Weekly")
	$MainVBox/TabBar.add_tab("Monthly")
	$MainVBox/TabBar.add_tab("All-Time")

func _load_leaderboard() -> void:
	$MainVBox/ScrollContainer/RankList/LoadingLabel.hide()

	var entries = [
		{ "rank": 1, "name": "SlemanMania_1976", "xp": 12500, "cards": 45 },
		{ "rank": 2, "name": "BCS_CurvaSud", "xp": 11200, "cards": 42 },
		{ "rank": 3, "name": "ElangJawa_Fan", "xp": 10800, "cards": 38 },
		{ "rank": 4, "name": "Maguwoharjo_12", "xp": 9500, "cards": 35 },
		{ "rank": 5, "name": "PSS_Forever", "xp": 9200, "cards": 33 },
		{ "rank": 6, "name": "SampaiKauBisa", "xp": 8800, "cards": 30 },
		{ "rank": 7, "name": "Falcao_Wings", "xp": 7500, "cards": 28 },
		{ "rank": 8, "name": "SuperElja_88", "xp": 7200, "cards": 25 },
		{ "rank": 9, "name": "Tridadi_Legend", "xp": 6900, "cards": 22 },
		{ "rank": 10, "name": "Sleman_Pride", "xp": 6500, "cards": 20 },
	]

	for entry in entries:
		$MainVBox/ScrollContainer/RankList.add_child(_make_rank_row(entry["rank"], entry["name"], entry["xp"], entry["cards"]))

	var player_name = GameManager.username if GameManager.username != "" else "You"
	$MainVBox/YourRank.text = "Your Rank: #42 — %s | ⭐ %d XP | 📇 %d cards" % [player_name, GameManager.xp, GameManager.get_card_count()]

func _make_rank_row(rank: int, name: String, xp: int, cards: int) -> Control:
	var row = HBoxContainer.new()

	var rank_icon = ""
	var rank_color = Color.WHITE
	match rank:
		1: rank_icon = "🥇 "; rank_color = Color(1.0, 0.85, 0.0)
		2: rank_icon = "🥈 "; rank_color = Color(0.75, 0.75, 0.8)
		3: rank_icon = "🥉 "; rank_color = Color(0.8, 0.5, 0.2)

	var rank_label = Label.new()
	rank_label.text = "%s#%d" % [rank_icon, rank]
	rank_label.add_theme_font_size_override("font_size", 18)
	rank_label.add_theme_color_override("font_color", rank_color)
	rank_label.custom_minimum_size = Vector2(80, 30)
	row.add_child(rank_label)

	var name_label = Label.new()
	name_label.text = name
	name_label.add_theme_font_size_override("font_size", 16)
	name_label.add_theme_color_override("font_color", Color.WHITE)
	name_label.custom_minimum_size = Vector2(320, 30)
	row.add_child(name_label)

	var xp_label = Label.new()
	xp_label.text = "⭐ %d" % xp
	xp_label.add_theme_font_size_override("font_size", 14)
	xp_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8, 1.0))
	xp_label.custom_minimum_size = Vector2(120, 30)
	xp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	row.add_child(xp_label)

	var cards_label = Label.new()
	cards_label.text = "📇 %d" % cards
	cards_label.add_theme_font_size_override("font_size", 14)
	cards_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8, 1.0))
	cards_label.custom_minimum_size = Vector2(100, 30)
	cards_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	row.add_child(cards_label)

	return row
