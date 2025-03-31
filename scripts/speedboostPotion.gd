extends Node2D

signal took_speed_boost

func _on_speedboost_body_entered(body):
	emit_signal("took_speed_boost")
	queue_free()
