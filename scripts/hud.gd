extends Control

func set_time_label(value):
	$TimeLabel.text = "Time:" + str(value)

func set_death_label(value):
	$death_counter.text = "Deaths:" + str(value)
