extends Node2D


@onready var main_countdown_label = $CanvasLayer/MainCountdownLabel
@onready var main_countdown = $CanvasLayer/MainCountdown


func _ready():
	main_countdown.start()
	
	
func time_left_to_live():
	var time_left = main_countdown.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]
	
	
func _process(delta):
	main_countdown_label.text = "%02d:%02d" % time_left_to_live()
