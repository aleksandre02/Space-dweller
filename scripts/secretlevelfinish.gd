extends Control

@onready var deathcounter = $Death_counter_secret

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/startmenu.tscn")


func set_death_label_win_scrn_secret(value):
	deathcounter.text = "Death Counter: " + str(value)
