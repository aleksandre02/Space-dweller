extends CharacterBody2D

class_name Player

enum Potion_type {JUMP_BOOST, SPEED_BOOST, INVINCIBILITY , SLOW_DOWN}

const PLAYER_SHOOT_COOLDOWN = 3
var bullet_scene = preload("res://scenes/bullet.tscn")
@export var gravity = 400
@export var speed = 125.0
@export var jump_force = 200

@onready var percentage_of_time
@onready var percentage_of_time_potion

@onready var jump_boost_particle_effects = $jumpboostparticles
@onready var invincibility_particle_effects = $"invincibility particles"
@onready var speed_boost_particles = $"speedboost particles"
@onready var slow_time_particles = $slowtimeparticles
@onready var collision_shape = $CollisionShape2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var reload_timer_progress = $TextureProgressBar
@onready var reload_timer = $reload_timer
@onready var potion_timer = $Potion_timer
@onready var potion_progress_bar = $PotionProgressBar
@onready var empty_potion = $PotionEmpty
var player_facing_right = true

var potion_picked_up : Potion_type

var max_jump_count = 2
var jump_count = 0
var potion_consumed = 0

var is_bullet_shot = false
func _ready():
	pass


func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot()
		reload_timer_progress.visible = true
	#Shuriken Reload timer
	if reload_timer.get_time_left() > 0:
		percentage_of_time = ((1 - reload_timer.get_time_left() / reload_timer.get_wait_time()) * 100)
		reload_timer_progress.value = percentage_of_time
		if percentage_of_time > 99:
			reload_timer_progress.visible = false
	#Potion timer
	if potion_consumed == 1:
		potion_progress_bar.visible = true
		empty_potion.visible = true
	if potion_timer.get_time_left() > 0:
		match potion_picked_up:
			Potion_type.JUMP_BOOST:
				empty_potion.texture = load("res://martian_mike_assets/textures/other/empty_round.png")
				potion_progress_bar.texture_progress = load("res://martian_mike_assets/textures/other/green_round.png")
			Potion_type.INVINCIBILITY:
				empty_potion.texture = load("res://martian_mike_assets/textures/other/empty_diamond.png")
				potion_progress_bar.texture_progress = load("res://martian_mike_assets/textures/other/blue_diamond.png")
			Potion_type.SPEED_BOOST:
				empty_potion.texture = load("res://martian_mike_assets/textures/other/empty_vial.png")
				potion_progress_bar.texture_progress = load("res://martian_mike_assets/textures/other/white_vial.png")
			Potion_type.SLOW_DOWN:
				empty_potion.texture = load("res://martian_mike_assets/textures/other/empty_moon.png")
				potion_progress_bar.texture_progress = load("res://martian_mike_assets/textures/other/black_moon.png")
		percentage_of_time_potion = (( potion_timer.get_time_left() / potion_timer.get_wait_time()) * 100)
		potion_progress_bar.value = percentage_of_time_potion
		if percentage_of_time_potion < 1:
			empty_potion.visible = false
			potion_progress_bar.visible = false
		
func _physics_process(delta):
	if is_on_floor() == false :
		velocity.y += gravity * delta
		if velocity.y > 500:
			velocity.y = 500
	else:
		jump_count = max_jump_count
	var direction = 0
	
	if Input.is_action_just_pressed("jump") && (is_on_floor() || jump_count > 0):
		jump(jump_force)
		
	direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		animated_sprite.flip_h = (direction == -1)
		player_facing_right = (direction != -1)

	velocity.x = direction * speed
	move_and_slide()
	update_animations(direction)
	
func jump(force):
	AudioPlayer.play_sfx("jump")
	velocity.y = -force
	jump_count -= 1

func update_animations(direction):
	if is_on_floor():  
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")

func shoot():	
	if !is_bullet_shot:
		AudioPlayer.play_sfx("shoot")
		var bullet_instance = bullet_scene.instantiate()
		add_child(bullet_instance)
		bullet_instance.is_facing_right = player_facing_right
		is_bullet_shot = true
		reload_timer.start()


func _on_reload_timer_timeout():
	is_bullet_shot = false

func consume_jump_potion():
	potion_picked_up = Potion_type.JUMP_BOOST
	potion_consumed = 1
	potion_timer.start()
	jump_force = 300
	jump_boost_particle_effects.visible = true
	await get_tree().create_timer(5).timeout
	jump_boost_particle_effects.visible = false
	jump_force = 200
	potion_consumed = 0
	
func consume_invincibility_potion():
	potion_picked_up = Potion_type.INVINCIBILITY	
	potion_consumed = 1
	potion_timer.start()
	invincibility_particle_effects.visible = true
	await get_tree().create_timer(5).timeout
	invincibility_particle_effects.visible = false
	potion_consumed = 0
	
func consume_slowdown_potion():
	potion_picked_up = Potion_type.SLOW_DOWN		
	potion_consumed = 1
	potion_timer.start()
	slow_time_particles.visible = true
	await get_tree().create_timer(5).timeout
	slow_time_particles.visible = false
	potion_consumed = 0
	
func consume_speed_potion():
	potion_picked_up = Potion_type.SPEED_BOOST	
	potion_consumed = 1
	potion_timer.start()
	speed = 175.0
	speed_boost_particles.visible = true
	await get_tree().create_timer(5).timeout
	speed_boost_particles.visible = false
	speed = 125.0
	potion_consumed = 0

func _on_level_player_took_invincibility():
	consume_invincibility_potion()
	
func _on_level_player_took_jump_boost():
	consume_jump_potion()

func _on_level_player_took_speed_boost():
	consume_speed_potion()

func _on_level_player_took_slow_time():
	consume_slowdown_potion()

func _on_level_3_player_took_jump_boost():
	consume_jump_potion()


func _on_level_3_player_took_invincibility():
	consume_invincibility_potion()


func _on_level_4_player_took_jump_boost():
	consume_jump_potion()


func _on_level_5_player_took_speed_boost():
	consume_speed_potion()


func _on_level_6_player_took_jump_boost():
	consume_jump_potion()


func _on_level_6_player_took_speed_boost():
	consume_speed_potion()


func _on_level_7_player_took_invincibility():
	consume_invincibility_potion()


func _on_level_7_player_took_slow_time():
	consume_slowdown_potion()


func _on_level_7_player_took_speed_boost():
	consume_speed_potion()
	


func _on_level_7_player_took_jump_boost():
	consume_jump_potion()
	


func _on_level_8_player_took_jump_boost():
	consume_jump_potion()
	

func _on_level_8_player_took_speed_boost():
	consume_speed_potion()


func _on_level_8_player_took_invincibility():
	consume_invincibility_potion()
	
	
func _on_level_9_player_took_invincibility():
	consume_invincibility_potion()


func _on_level_9_player_took_jump_boost():
	consume_jump_potion()


func _on_level_9_player_took_slow_time():
	consume_slowdown_potion()


func _on_level_9_player_took_speed_boost():
	consume_speed_potion()


func _on_level_final_player_took_invincibility():
	consume_invincibility_potion()


func _on_level_final_player_took_jump_boost():
	consume_jump_potion()


func _on_level_final_player_took_slow_time():
	consume_slowdown_potion()


func _on_level_final_player_took_speed_boost():
	consume_speed_potion()
