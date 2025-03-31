extends Node2D

signal took_invincibility

func _on_invincibility_body_entered(body):
	emit_signal("took_invincibility")
	queue_free()
	
