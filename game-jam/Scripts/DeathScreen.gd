extends Node

func _ready():
	set_process_input(true)
	pass

func _input(event):
	if event.get_class() == 'InputEventKey':
		get_tree().change_scene("res://Scenes/GameScene.tscn")

		
func _exit_tree():
	set_process_input(false)