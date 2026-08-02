extends Control
## Main menu / lobby controller

@onready var coins_label = $TopBar/CoinsLabel
@onready var xp_label = $TopBar/XPContainer/XPLabel
@onready var rpp_label = $TopBar/XPContainer/RPPLabel
@onready var lives_label = $TopBar/LivesLabel
@onready var season_info = $SeasonInfo

func _ready() -> void:
	_update_display()
	_connect_signals()

func _connect_signals() -> void:
	GameManager.coins_changed.connect(_on_coins_changed)
	GameManager.xp_changed.connect(_on_xp_changed)
	GameManager.rpp_changed.connect(_on_rpp_changed)
	GameManager.lives_changed.connect(_on_lives_changed)

	$ButtonContainer/PlayButton.pressed.connect(_on_play_pressed)
	$ButtonContainer/AlbumButton.pressed.connect(_on_album_pressed)
	$ButtonContainer/ShopButton.pressed.connect(_on_shop_pressed)
	$ButtonContainer/LeaderboardButton.pressed.connect(_on_leaderboard_pressed)

func _update_display() -> void:
	coins_label.text = "🪙 %d" % GameManager.coins
	xp_label.text = "⭐ %d" % GameManager.xp
	rpp_label.text = "💎 %d" % GameManager.rpp
	lives_label.text = "❤️ %d" % GameManager.lives
	var seasons = Config.get_season_config()
	var season = seasons[GameManager.current_season - 1]
	season_info.text = "Season %d: %s (%s)" % [season.id, season.name, season.years]

func _on_coins_changed(amount: int) -> void: coins_label.text = "🪙 %d" % amount
func _on_xp_changed(amount: int) -> void: xp_label.text = "⭐ %d" % amount
func _on_rpp_changed(amount: int) -> void: rpp_label.text = "💎 %d" % amount
func _on_lives_changed(amount: int) -> void: lives_label.text = "❤️ %d" % amount

func _on_play_pressed() -> void:
	if not GameManager.use_life():
		_show_popup("No Lives!", "Wait for regeneration or buy lives in the shop.")
		return
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_album_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/album.tscn")

func _on_shop_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/shop.tscn")

func _on_leaderboard_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")

func _show_popup(title: String, message: String) -> void:
	var popup = AcceptDialog.new()
	popup.title = title
	popup.dialog_text = message
	add_child(popup)
	popup.popup_centered()
