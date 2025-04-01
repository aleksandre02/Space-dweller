extends Control


func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/level.tscn")
	Global.death_counter = 0

func _on_exit_pressed():
	get_tree().quit()

func _on_help_pressed():
		get_tree().change_scene_to_file("res://scenes/help_screen.tscn")
