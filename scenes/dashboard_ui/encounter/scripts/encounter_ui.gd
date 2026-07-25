extends Control
class_name EncounterUI

@export var lucarne: TextureRect
@export var description: Label
@export var wave_form: Label
@export var type_color_rect: ColorRect
@onready var reponse: Label = %Reponse

func update_encounter_ui(encounter :  Encounter)->void:
	if encounter == null:
		encounter = Encounter.new()
	lucarne.texture = encounter.sprite
	reponse.text = "Reponse:" + encounter.response
	description.text = "Description:" + encounter.description
	wave_form.text = "Wave Form:" + str(encounter.wave_form)
	if type_color_rect != null:
		if encounter.sprite == null:
			type_color_rect.color = Color.WHITE
		else:
			type_color_rect.color = type2color(encounter.type)
			

func type2color (encounter_type : Encounter.Type) -> Color :
	match encounter_type:
		Encounter.Type.PASSIVE:
			return Color.GREEN
		Encounter.Type.AGRESSIVE:
			return Color.RED
		Encounter.Type.TARGET:
			return Color.DEEP_SKY_BLUE
	return Color.BLACK
