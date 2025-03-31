extends Node2D

signal took_jump_boost

func _on_jumpboost_body_entered(body):
	emit_signal("took_jump_boost")
	queue_free()
