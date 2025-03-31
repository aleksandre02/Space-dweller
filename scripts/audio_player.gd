extends Node

var hurt = preload("res://martian_mike_assets/audio/hurt.wav")
var jump = preload("res://martian_mike_assets/audio/jump.wav")
var shoot = preload("res://martian_mike_assets/audio/bubble-laser-fx.wav")

func play_sfx(sfx_name: String):
	var asp = AudioStreamPlayer.new()
	var stream = null
	if sfx_name == "hurt":
		stream = hurt
	elif sfx_name == "jump":
		stream = jump
	elif sfx_name == "shoot":
		stream = shoot
	else:
		print("invalid sfx namxe")
		return
	asp.stream = stream
	asp.name = "SFX"
	add_child(asp)
	asp.play()
	await asp.finished
	asp.queue_free()
