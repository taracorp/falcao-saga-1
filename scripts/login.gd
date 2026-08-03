extends Control
func _ready():
	$BtnGoogle.pressed.connect(func(): pass)
	$BtnTamu.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/03_beranda.tscn"))
