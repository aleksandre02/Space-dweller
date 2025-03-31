extends Node2D

signal took_time_slow

func _on_timeslow_body_entered(body):
	emit_signal("took_time_slow")
	queue_free()
