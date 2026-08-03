extends Control

@onready var coins_label = $Coins
@onready var xp_label = $XP
@onready var rpp_label = $RPP
@onready var lives_label = $Lives
@onready var season_info = $Season

func _ready() -> void:
	_update_display()
	GameManager.coins_changed.connect(func(v): coins_label.text = "🪙 %d" % v)
	GameManager.xp_changed.connect(func(v): xp_label.text = "⭐ %d" % v)
	GameManager.rpp_changed.connect(func(v): rpp_label.text = "💎 %d" % v)
	GameManager.lives_changed.connect(func(v): lives_label.text = "❤️ %d" % v)
	$BtnPlay.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/game.tscn"))
	$BtnAlbum.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/album.tscn"))
	$BtnShop.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/shop.tscn"))
	$BtnLeaderboard.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/leaderboard.tscn"))

func _update_display() -> void:
	coins_label.text = "🪙 %d" % GameManager.coins
	xp_label.text = "⭐ %d" % GameManager.xp
	rpp_label.text = "💎 %d" % GameManager.rpp
	lives_label.text = "❤️ %d" % GameManager.lives
	var s = Config.get_season_config()[GameManager.current_season - 1]
	season_info.text = "Season %d: %s (%s)" % [s.id, s.name, s.years]
