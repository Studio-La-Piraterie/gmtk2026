@tool
extends Control

@export var encounter : Encounter = Encounter.new() :
	set = _set_encounter

@onready var lucarne: TextureRect = %Lucarne
@onready var reponse: Label = %Reponse
@onready var description: Label = %Description
@onready var wave_form: Label = %WaveForm
@onready var type: ColorRect = %Type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_encounter(encounter)

func _set_encounter(new_encounter : Encounter) -> void:
	print("New encounter loaded")

	if not is_node_ready() :
		return
	
	if new_encounter == null:
		new_encounter = Encounter.new()
	
	encounter = new_encounter
	print("New encounter loaded")
	lucarne.texture = encounter.sprite
	reponse.text = "Reponse:" + encounter.response
	description.text = "Description:" + encounter.description
	wave_form.text = "Wave Form:" + str(encounter.wave_form)
	type.color = type2color(encounter.type)
	
func type2color (encounter_type : Encounter.Type) -> Color :
	match encounter_type:
		Encounter.Type.PASSIVE:
			return Color.GREEN
		Encounter.Type.AGRESSIVE:
			return Color.RED
		Encounter.Type.TARGET:
			return Color.DEEP_SKY_BLUE
	return Color.BLACK
