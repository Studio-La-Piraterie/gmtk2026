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
		
	if min_encounter_value<=value && value<=max_encounter_value:
		show_player()
	else :
		hide_player()

func update(oscillo_gif : GIFTexture, min_encounter_val : float, max_encounter_val : float):
	oscilloscope_player.gif = oscillo_gif
	min_encounter_value = clampf(min_encounter_val,0.0,100.0) 
	max_encounter_value = clampf(max_encounter_val,min_encounter_value,100.0)

func disable() -> void:
	disabled = true

func enable() -> void:
	disabled = false

func show_player() -> void:
	oscilloscope_player.show()
	
func hide_player() -> void :
	oscilloscope_player.hide()
