extends Control
## Card pack opening animation overlay

signal pack_closed

var _cards_to_reveal: Array = []
var _current_index: int = 0

func open_pack(cards: Array) -> void:
	_cards_to_reveal = cards
	_current_index = 0
	_show_next_card()

func _show_next_card() -> void:
	if _current_index >= _cards_to_reveal.size():
		_close()
		return

	for child in get_children():
		if child != $Background:
			child.queue_free()

	var card_data = _cards_to_reveal[_current_index]
	_create_card_display(card_data["card_id"], card_data["rarity"], card_data.get("foil", false))
	_current_index += 1

func _create_card_display(card_id: int, rarity: int, is_foil: bool) -> void:
	# Card background
	var card = Panel.new()
	card.custom_minimum_size = Vector2(350, 450)
	card.position = Vector2(185, 200)

	var bg = ColorRect.new()
	bg.size = Vector2(350, 450)
	bg.color = Color(0.1, 0.1, 0.15, 1.0)
	card.add_child(bg)

	# Rarity border
	var border = ColorRect.new()
	border.size = Vector2(346, 446)
	border.position = Vector2(2, 2)
	border.color = Config.get_rarity_color(rarity)
	card.add_child(border)

	# Card ID
	var id_label = Label.new()
	id_label.text = "PSS Player #%d" % card_id
	id_label.add_theme_font_size_override("font_size", 22)
	id_label.add_theme_color_override("font_color", Color.WHITE)
	id_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	id_label.position = Vector2(0, 80)
	id_label.size = Vector2(350, 40)
	card.add_child(id_label)

	# Rarity name
	var rarity_label = Label.new()
	rarity_label.text = "[%s]" % Config.get_rarity_name(rarity)
	rarity_label.add_theme_font_size_override("font_size", 18)
	rarity_label.add_theme_color_override("font_color", Config.get_rarity_color(rarity))
	rarity_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	rarity_label.position = Vector2(0, 130)
	rarity_label.size = Vector2(350, 30)
	card.add_child(rarity_label)

	# Foil badge
	if is_foil:
		var foil = Label.new()
		foil.text = "✨ FOIL ✨"
		foil.add_theme_font_size_override("font_size", 16)
		foil.add_theme_color_override("font_color", Color(1.0, 0.5, 1.0, 1.0))
		foil.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		foil.position = Vector2(0, 170)
		foil.size = Vector2(350, 30)
		card.add_child(foil)

	# Tap to continue
	var tap_label = Label.new()
	tap_label.text = "Tap to reveal next..."
	tap_label.add_theme_font_size_override("font_size", 14)
	tap_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6, 1.0))
	tap_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tap_label.position = Vector2(0, 380)
	tap_label.size = Vector2(350, 50)
	card.add_child(tap_label)

	add_child(card)

	# Entrance animation
	card.scale = Vector2(0.1, 0.1)
	card.modulate.a = 0
	var tween = create_tween().set_parallel(true)
	tween.tween_property(card, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_OUT_BACK)
	tween.tween_property(card, "modulate:a", 1.0, 0.2)

	# Click to continue
	var click_area = Button.new()
	click_area.flat = true
	click_area.size = Vector2(350, 450)
	click_area.position = Vector2(185, 200)
	click_area.modulate.a = 0
	click_area.pressed.connect(_show_next_card)
	add_child(click_area)

func _close() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_callback(queue_free)
	pack_closed.emit()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_show_next_card()

# Background
func _ready() -> void:
	var bg = ColorRect.new()
	bg.name = "Background"
	bg.size = Vector2(720, 1280)
	bg.color = Color(0, 0, 0, 0.8)
	add_child(bg)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
