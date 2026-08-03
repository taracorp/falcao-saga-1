extends Control

func _ready():
	$Btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/02_login.tscn"))
