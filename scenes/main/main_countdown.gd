class_name  MainCountdown extends Label

@export var blink_time : float = 0.1

func update_main_countdown(time_left : float) -> void:
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	text = "%02d:%02d" % [minute,second]

func animate_time_skip(from_time :float, to_time : float) -> void:
	visible = true
	await get_tree().create_timer(blink_time).timeout
	visible = false
	await get_tree().create_timer(blink_time).timeout
	visible = true
	await get_tree().create_timer(blink_time).timeout
	visible = false
	await get_tree().create_timer(blink_time).timeout
	visible = true
	
	
