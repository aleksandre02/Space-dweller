extends CanvasLayer

@onready var pause_node = $Pause

var paused = false

func show_win_screen(flag: bool):
	$WinScreen.visible = flag
	
	
func show_secret_win_screen(flag: bool):
	$secretlevelfinish.visible = flag
func _on_exit_pressed():
	get_tree().change_scene_to_file("res://scenes/startmenu.tscn")

func pause_menu():
	if paused:
		pause_node.hide()
		Engine.time_scale = 1
	else:
		pause_node.show()
		Engine.time_scale = 0
	paused = !paused
