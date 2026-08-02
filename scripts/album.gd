extends Control
## Album / Card Collection Gallery

var _current_season: int = 1

func _ready() -> void:
	_populate_season_selector()
	_refresh()

func _populate_season_selector() -> void:
	var selector = $SeasonSelector
	for season in Config.get_season_config():
		var label = "S%d: %s (%s)" % [season.id, season.name, season.years]
		selector.add_item(label, season.id)
		# Dim locked seasons
		if GameManager.current_season < season.id:
			selector.set_item_disabled(season.id - 1, true)
	selector.item_selected.connect(_on_season_selected)

func _on_season_selected(index: int) -> void:
	_current_season = $SeasonSelector.get_item_id(index)
	_refresh()

func _refresh() -> void:
	_clear_grid()
	_render_cards()
	_update_progress()

func _clear_grid() -> void:
	for child in $CardGrid.get_children():
		child.queue_free()

func _render_cards() -> void:
	var seasons = Config.get_season_config()
	var season_data = seasons[_current_season - 1]
	var start_id = (_current_season - 1) * 20 + 1
	var end_id = start_id + season_data["count"] - 1

	for card_id in range(start_id, end_id + 1):
		var card = _make_card(card_id)
		$CardGrid.add_child(card)

func _make_card(card_id: int) -> Control:
	var card = Panel.new()
	card.custom_minimum_size = Vector2(160, 200)

	var bg = ColorRect.new()
	bg.size = Vector2(160, 200)
	bg.color = Color(0.15, 0.15, 0.2, 1.0)
	card.add_child(bg)

	if GameManager.has_card(card_id):
		var data = GameManager.cards[str(card_id)]
		var rarity = int(data.get("foil", false)) + 1  # simplified
		var color = Config.get_rarity_color(rarity)
		var border = ColorRect.new()
		border.size = Vector2(156, 196)
		border.position = Vector2(2, 2)
		border.color = color
		card.add_child(border)

		var name = Label.new()
		name.text = "Card #%d" % card_id
		name.add_theme_font_size_override("font_size", 12)
		name.add_theme_color_override("font_color", Color.WHITE)
		name.position = Vector2(10, 10)
		name.size = Vector2(140, 20)
		card.add_child(name)

		var count = Label.new()
		count.text = "x%d" % data.get("quantity", 1)
		count.add_theme_font_size_override("font_size", 14)
		count.add_theme_color_override("font_color", Color.WHITE)
		count.position = Vector2(10, 170)
		count.size = Vector2(140, 20)
		count.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		card.add_child(count)

		if data.get("is_foil", false):
			var foil = Label.new()
			foil.text = "✨ FOIL"
			foil.add_theme_font_size_override("font_size", 10)
			foil.add_theme_color_override("font_color", Color(1.0, 0.5, 1.0, 1.0))
			foil.position = Vector2(10, 30)
			card.add_child(foil)
	else:
		var unknown = Label.new()
		unknown.text = "?"
		unknown.add_theme_font_size_override("font_size", 36)
		unknown.add_theme_color_override("font_color", Color(0.4, 0.4, 0.4, 1.0))
		unknown.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		unknown.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		unknown.size = Vector2(160, 200)
		card.add_child(unknown)

	return card

func _update_progress() -> void:
	var total = Config.get_season_config()[_current_season - 1]["count"]
	var owned = 0
	for card_id in GameManager.cards:
		var card_season = ((int(card_id) - 1) / 20) + 1
		if card_season == _current_season:
			owned += 1
	$ProgressLabel.text = "Progress: %d/%d cards (%.0f%%)" % [owned, total, float(owned)/float(total)*100]

func _on_back_pressed() -> void:
	$BackButton.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main.tscn"))
