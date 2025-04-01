extends Control

@onready var deathcounter = $death_counter


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/startmenu.tscn")

func set_death_label_win_scrn_secret(value):
	deathcounter.text = "Death Counter: " + str(value)


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://scenes/level_final.tscn")

func _process(delta):
	set_death_label_win_scrn_secret(Global.death_counter)
