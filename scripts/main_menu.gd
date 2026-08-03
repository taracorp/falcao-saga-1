extends Node2D

@onready var coins_label = $UI/Coins
@onready var xp_label = $UI/XP
@onready var rpp_label = $UI/RPP
@onready var lives_label = $UI/Lives
@onready var season_info = $UI/Season

func _ready() -> void:
	_update_display()
	GameManager.coins_changed.connect(func(v): coins_label.text = "🪙 %d" % v)
	GameManager.xp_changed.connect(func(v): xp_label.text = "⭐ %d" % v)
	GameManager.rpp_changed.connect(func(v): rpp_label.text = "💎 %d" % v)
	GameManager.lives_changed.connect(func(v): lives_label.text = "❤️ %d" % v)
	$UI/BtnPlay.pressed.connect(_on_play)
	$UI/BtnAlbum.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/album.tscn"))
	$UI/BtnShop.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/shop.tscn"))
	$UI/BtnLeaderboard.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/leaderboard.tscn"))

func _update_display() -> void:
	coins_label.text = "🪙 %d" % GameManager.coins
	xp_label.text = "⭐ %d" % GameManager.xp
	rpp_label.text = "💎 %d" % GameManager.rpp
	lives_label.text = "❤️ %d" % GameManager.lives
	var s = Config.get_season_config()[GameManager.current_season - 1]
	season_info.text = "Season %d: %s (%s)" % [s.id, s.name, s.years]

func _on_play() -> void:
	if not GameManager.use_life():
		var p = AcceptDialog.new(); p.title = "No Lives!"; p.dialog_text = "Wait or buy lives."; add_child(p); p.popup_centered()
		return
	get_tree().change_scene_to_file("res://scenes/game.tscn")
