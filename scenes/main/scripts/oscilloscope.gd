class_name Oscilloscope extends Node

@export var oscilloscope_player : GIFPlayer = null
@export var slider : Slider

var min_encounter_value : float = 50
var max_encounter_value : float = 100

var disabled := false

func _physics_process(_delta: float) -> void:
	_check_slider(slider.value)
	
func _check_slider(value : float) -> void:
	if disabled:
		hide_player()
		return
		
	if min_encounter_value<value && value<max_encounter_value:
		show_player()
	else :
		hide_player()

func disable() -> void:
	disabled = true

func enable() -> void:
	disabled = false

func show_player() -> void:
	oscilloscope_player.show()
	
func hide_player() -> void :
	oscilloscope_player.hide()
