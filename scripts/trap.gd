extends Node2D

class_name Traps

signal touched_player

@onready var collision_shape = $Area2D/CollisionShape2D
@onready var animation_player = $AnimationPlayer

var is_trap_frozen = false 

func _on_area_2d_body_entered(body):
	if !is_trap_frozen && body is Player:
		touched_player.emit()
	
func freeze():
	is_trap_frozen = true
	self.modulate = Color(0,212,255,255)
	animation_player.active = false
	await get_tree().create_timer(3).timeout
	is_trap_frozen = false
	self.modulate = Color(1,1,1)
	animation_player.active = true
	

func _ready():
	pass

func _on_area_2d_area_entered(area):
	freeze()
	
