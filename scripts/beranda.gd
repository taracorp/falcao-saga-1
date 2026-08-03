extends Control
func _ready():
	$BtnMain.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/04_game.tscn"))
	$Nav1.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/05_koleksi.tscn"))
	$Nav2.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/06_toko.tscn"))
	$Nav4.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/07_peringkat.tscn"))
	$Coins.text = "🪙 %d" % GameManager.coins
	$RPP.text = "💎 %d" % GameManager.rpp
	$SeasonProgress.text = "%d/18 kartu terkumpul" % GameManager.get_card_count()
