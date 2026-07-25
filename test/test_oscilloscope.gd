extends Oscilloscope

@onready var enable_textt: Label = %EnableTextt
@onready var enable_btn: Button = %EnableBtn
@onready var change_gif: Button = $ChangeGif

const ONDE : GIFTexture = preload("res://assets/oscilloscoope/ONDE.gif")
const PENGUIN : GIFTexture = preload("res://assets/oscilloscoope/yeojinvevo-penguin-missile.gif")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enable_btn.pressed.connect(switch_oscillo)
	change_gif.pressed.connect(
		func()->void:
			if oscilloscope_player.gif == ONDE:
				change_displayed_oscillo(PENGUIN,10,20)
			else:
				change_displayed_oscillo(ONDE,50,100)
			)
	
func switch_oscillo()->void:
	if disabled:
		enable()
		enable_textt.text = "Oscilloscope disbaled : "+ str(disabled)
	else:
		disable()
		enable_textt.text = "Oscilloscope state : "+ str(disabled)
		
func change_displayed_oscillo(gif : GIFTexture, new_min : float, new_max: float) ->void:
		oscilloscope_player.gif = gif
		min_encounter_value = new_min
		max_encounter_value = new_max
