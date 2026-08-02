extends Control
## Shop for power-ups, card packs, and reward redemption

enum Tab { POWERUPS, PACKS, REDEEM }

var _current_tab: Tab = Tab.POWERUPS

func _ready() -> void:
	$TopBar/BackButton.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main.tscn"))
	_update_balance()
	_setup_tabs()
	_render_tab(Tab.POWERUPS)

func _update_balance() -> void:
	$MainVBox/BalanceLabel.text = "🪙 Coins: %d  |  💎 RPP: %d" % [GameManager.coins, GameManager.rpp]

func _setup_tabs() -> void:
	$MainVBox/TabBar.add_tab("Power-Ups")
	$MainVBox/TabBar.add_tab("Card Packs")
	$MainVBox/TabBar.add_tab("Redeem RPP")
	$MainVBox/TabBar.tab_changed.connect(_on_tab_changed)

func _on_tab_changed(tab: int) -> void:
	_render_tab(tab as Tab)

func _render_tab(tab: Tab) -> void:
	_current_tab = tab
	for child in $MainVBox/ShopGrid.get_children():
		child.queue_free()
	match tab:
		Tab.POWERUPS: _render_powerups()
		Tab.PACKS: _render_packs()
		Tab.REDEEM: _render_redeem()

func _render_powerups() -> void:
	var items = [
		{ "name": "+5 Moves", "desc": "5 extra moves", "cost": 200, "icon": "🎯" },
		{ "name": "Hammer", "desc": "Destroy 1 cell", "cost": 150, "icon": "🔨" },
		{ "name": "Bom Suporter", "desc": "Destroy 3x3 area", "cost": 300, "icon": "💣" },
		{ "name": "+3 Nyawa", "desc": "Refill 3 lives", "cost": 500, "icon": "❤️" },
	]
	for item in items:
		$MainVBox/ShopGrid.add_child(_make_shop_item(item["name"], item["desc"], item["cost"], item["icon"], true, func():
			if GameManager.spend_coins(item["cost"]):
				if item["name"] == "+3 Nyawa":
					for _i in range(3): GameManager.recover_life()
				_update_balance()
		))

func _render_packs() -> void:
	var items = [
		{ "name": "Common Pack", "desc": "5 cards, 1 Rare+", "cost": 500, "icon": "📦" },
		{ "name": "Premium Pack", "desc": "5 cards, 1 Epic+", "cost": 1500, "icon": "✨" },
		{ "name": "Season Pack", "desc": "5 cards, same season", "cost": 2000, "icon": "🎁" },
	]
	for item in items:
		$MainVBox/ShopGrid.add_child(_make_shop_item(item["name"], item["desc"], item["cost"], item["icon"], true, func():
			if GameManager.spend_coins(item["cost"]):
				_open_pack(item["name"])
				_update_balance()
		))

func _render_redeem() -> void:
	var info = Label.new()
	info.text = "Loading rewards..."
	info.add_theme_font_size_override("font_size", 16)
	$MainVBox/ShopGrid.add_child(info)

	if SupabaseClient.is_logged_in():
		SupabaseClient.fetch_rewards()
		await SupabaseClient.data_loaded
	else:
		_render_local_rewards()

func _render_local_rewards() -> void:
	for child in $ShopGrid.get_children():
		child.queue_free()

	var rewards = [
		{ "name": "Stiker PSS Digital", "rpp": 50, "tier": "bronze" },
		{ "name": "Wallpaper Eksklusif", "rpp": 100, "tier": "bronze" },
		{ "name": "Kartu Foil Legendary", "rpp": 200, "tier": "silver" },
		{ "name": "Jersey In-Game", "rpp": 300, "tier": "silver" },
		{ "name": "Gantungan Kunci PSS", "rpp": 500, "tier": "gold" },
		{ "name": "Syal PSS Sleman", "rpp": 1000, "tier": "gold" },
		{ "name": "Poster Tanda Tangan", "rpp": 1500, "tier": "gold" },
		{ "name": "Jersey PSS Original", "rpp": 3000, "tier": "diamond" },
		{ "name": "Tiket Pertandingan", "rpp": 5000, "tier": "diamond" },
		{ "name": "Meet & Greet Pemain", "rpp": 10000, "tier": "crown" },
		{ "name": "Nama di Jersey PSS", "rpp": 25000, "tier": "crown" },
	]

	for reward in rewards:
		$MainVBox/ShopGrid.add_child(_make_redeem_item(reward["name"], reward["rpp"], reward["tier"]))

func _make_shop_item(name: String, desc: String, cost: int, icon: String, use_coins: bool, callback: Callable) -> Control:
	var panel = Panel.new()
	panel.custom_minimum_size = Vector2(340, 120)
	panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER

	var bg = ColorRect.new()
	bg.size = Vector2(340, 120)
	bg.color = Color(0.15, 0.18, 0.15, 1.0)
	panel.add_child(bg)

	var name_label = Label.new()
	name_label.text = "%s  %s" % [icon, name]
	name_label.add_theme_font_size_override("font_size", 18)
	name_label.add_theme_color_override("font_color", Color.WHITE)
	name_label.position = Vector2(10, 10)
	name_label.size = Vector2(320, 25)
	panel.add_child(name_label)

	var desc_label = Label.new()
	desc_label.text = desc
	desc_label.add_theme_font_size_override("font_size", 12)
	desc_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7, 1.0))
	desc_label.position = Vector2(10, 40)
	desc_label.size = Vector2(320, 20)
	panel.add_child(desc_label)

	var btn = Button.new()
	btn.text = "🪙 %d" % cost if use_coins else "💎 %d RPP" % cost
	btn.add_theme_font_size_override("font_size", 14)
	btn.position = Vector2(200, 75)
	btn.size = Vector2(130, 35)
	btn.pressed.connect(callback)
	panel.add_child(btn)

	return panel

func _make_redeem_item(name: String, rpp: int, tier: String) -> Control:
	var panel = Panel.new()
	panel.custom_minimum_size = Vector2(340, 120)

	var color = Color.DIM_GRAY
	match tier:
		"bronze": color = Color(0.6, 0.4, 0.2)
		"silver": color = Color(0.6, 0.6, 0.7)
		"gold": color = Color(0.8, 0.7, 0.1)
		"diamond": color = Color(0.3, 0.7, 0.9)
		"crown": color = Color(0.9, 0.2, 0.9)

	var bg = ColorRect.new()
	bg.size = Vector2(340, 120)
	bg.color = Color(0.15, 0.18, 0.15, 1.0)
	panel.add_child(bg)

	var tier_label = Label.new()
	tier_label.text = tier.to_upper()
	tier_label.add_theme_font_size_override("font_size", 10)
	tier_label.add_theme_color_override("font_color", color)
	tier_label.position = Vector2(10, 5)
	panel.add_child(tier_label)

	var name_label = Label.new()
	name_label.text = name
	name_label.add_theme_font_size_override("font_size", 15)
	name_label.add_theme_color_override("font_color", Color.WHITE)
	name_label.position = Vector2(10, 25)
	name_label.size = Vector2(320, 20)
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	panel.add_child(name_label)

	var cost_label = Label.new()
	cost_label.text = "💎 %d RPP" % rpp
	cost_label.add_theme_font_size_override("font_size", 16)
	cost_label.add_theme_color_override("font_color", Color.CYAN)
	cost_label.position = Vector2(10, 75)
	panel.add_child(cost_label)

	var btn = Button.new()
	btn.text = "Redeem"
	btn.position = Vector2(250, 75)
	btn.size = Vector2(80, 35)
	btn.pressed.connect(func():
		if GameManager.spend_rpp(rpp):
			_show_popup("Redeemed!", "You redeemed: %s" % name)
		else:
			_show_popup("Not enough RPP", "Keep playing to earn more!")
	)
	panel.add_child(btn)

	return panel

func _open_pack(pack_type: String) -> void:
	var count = 5
	var cards = []
	for i in range(count):
		var card_id = randi() % 200 + 1
		var rarity = _roll_rarity()
		var foil = randf() < 0.05
		GameManager.add_card(card_id, rarity, foil)
		cards.append({ "card_id": card_id, "rarity": rarity, "foil": foil })

	# Show pack opening animation
	var pack_scene = load("res://scripts/card_pack_opener.gd")
	if pack_scene:
		var opener = pack_scene.new()
		add_child(opener)
		opener.open_pack(cards)
	else:
		var messages = []
		for c in cards:
			messages.append("Card #%d (%s)%s" % [c.card_id, Config.get_rarity_name(c.rarity), " FOIL" if c.foil else ""])
		_show_popup(pack_type, "\n".join(messages))

func _roll_rarity() -> int:
	var roll = randi() % 100
	var cumulative = 0
	for rarity in [Config.RARITY_COMMON, Config.RARITY_RARE, Config.RARITY_EPIC, Config.RARITY_LEGENDARY, Config.RARITY_MYTHIC]:
		cumulative += Config.get_drop_rate(rarity)
		if roll < cumulative:
			return rarity
	return Config.RARITY_COMMON

func _show_popup(title: String, message: String) -> void:
	var popup = AcceptDialog.new()
	popup.title = title
	popup.dialog_text = message
	add_child(popup)
	popup.popup_centered()
