extends Node2D



@export var next_level: PackedScene = null 
@export var is_final_level:bool = false
@export var level_time = 30

@onready var start = $Start
@onready var exit = $Exit
@onready var death_zone = $deathzone
@onready var hud = $UILayer/HUD
@onready var ui_layer = $UILayer
@onready var win_screen = $UILayer/WinScreen

signal player_took_invincibility
signal player_took_jump_boost
signal player_took_speed_boost
signal player_took_slow_time

var player = null


var timer_node = null
var time_left
var is_player_invincible = false
var win = false

func _ready():
	Engine.time_scale = 1
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		player.global_position = start.get_spawn_pos()	

	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		trap.touched_player.connect(_on_trap_touched_player)
		
	exit.body_entered.connect(_on_exit_body_entered)
	death_zone.body_entered.connect(_on_deathzone_body_entered)
	
	time_left = level_time
	hud.set_time_label(time_left)
	timer_node = Timer.new()
	timer_node.name = "Level Timer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start()
	
func _on_level_timer_timeout():
	if win == false:
		time_left -= 1
		hud.set_time_label(time_left)
		if time_left <= 0:
			AudioPlayer.play_sfx("hurt")
			reset_player()
			Global.death_counter += 1
			time_left = level_time
	
func _process(delta):
	hud.set_death_label(Global.death_counter)
	win_screen.set_death_label_win_scrn(Global.death_counter)
	if Input.is_action_just_pressed("pause"):
		ui_layer.pause_menu()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	#print(death_counter)

func _on_deathzone_body_entered(body):
	AudioPlayer.play_sfx("hurt")
	reset_player()
	Global.death_counter += 1


func _on_trap_touched_player():
	if !is_player_invincible:
		AudioPlayer.play_sfx("hurt")	
		reset_player()
		Global.death_counter += 1
	
func reset_player():
	get_tree().reload_current_scene()
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_pos()
	time_left = level_time
	
	
func _on_exit_body_entered(body):
	if body is Player:
		if is_final_level || (next_level != null):
			exit.animate()
			#player.active=false
			win = true
			await get_tree().create_timer(1.5).timeout
			if is_final_level:
				ui_layer.show_win_screen(true)
			else: 
				get_tree().change_scene_to_packed(next_level)


func _on_invincibility_potion_took_invincibility():
	is_player_invincible = true
	emit_signal("player_took_invincibility")
	await get_tree().create_timer(5).timeout
	is_player_invincible = false

func _on_jumpboostpotion_took_jump_boost():
	emit_signal("player_took_jump_boost")

func _on_speedboost_potion_took_speed_boost():
	emit_signal("player_took_speed_boost")

func _on_timeslowpotion_took_time_slow():
	Engine.time_scale = 0.5
	emit_signal("player_took_slow_time")
	await get_tree().create_timer(5).timeout
	Engine.time_scale = 1

	
