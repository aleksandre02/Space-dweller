extends Area2D

@onready var animated_sprite = $AnimatedSprite2D

@export var speed = 300

var position_y
var is_facing_right = true
var is_dead = false
var dead_position 

func _ready():
	position_y = global_position.y

func _physics_process(delta):
	if is_dead:
		global_position = dead_position
		return
	if is_facing_right:
		global_position.x += speed * delta 
	else:
		global_position.x -= speed * delta
	global_position.y = position_y -10
	
func _on_screen_exited():
	queue_free()

func _on_area_entered(area):
	animated_sprite.play("die")
	is_dead = true
	dead_position = global_position
	await get_tree().create_timer(1.5).timeout	
	queue_free()

func _on_body_entered(body):
	animated_sprite.play("die")
	is_dead = true
	dead_position = global_position
	await get_tree().create_timer(1.5).timeout
	queue_free()

