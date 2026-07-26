@tool
extends Control

@export var encounter : Encounter = Encounter.new() :
	set = _set_encounter

@export var encounter_ui: EncounterUI
@export var oscilloscope_ui: Oscilloscope
@onready var get_new_encounter_btn: Button = %GetNewEncounter

var encounter_dispenser := EncounterManager.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_encounter(encounter)
	add_child(encounter_dispenser)
	get_new_encounter_btn.pressed.connect(
		func()->void:
			_set_encounter(encounter_dispenser.get_new_encounter())
			)

func _set_encounter(new_encounter : Encounter) -> void:
	if not is_node_ready() :
		return
	
	if new_encounter == null:
		new_encounter = Encounter.new()
	
	encounter_ui.update_encounter_ui(encounter)
	
	AudioManager.play_encounter_audio(encounter.audio_stream)
	
	oscilloscope_ui.update(encounter.oscillo_gif, encounter.min_oscillo_val, encounter.max_oscillo_val)
	
func type2color (encounter_type : Encounter.Type) -> Color :
	match encounter_type:
		Encounter.Type.PASSIVE:
			return Color.GREEN
		Encounter.Type.AGRESSIVE:
			return Color.RED
		Encounter.Type.TARGET:
			return Color.DEEP_SKY_BLUE
	return Color.BLACK
