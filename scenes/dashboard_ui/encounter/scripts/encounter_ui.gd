extends Control
class_name EncounterUI

@export var lucarne: Control
@export var encounter_sprite: AnimatedSprite2D
@export var description: Label

func update_encounter_ui(encounter :  Encounter)->void:
	if encounter == null:
		encounter = Encounter.new()
	
	encounter_sprite.sprite_frames = encounter.sprite

	description.text = encounter.description
	#if type_color_rect != null:
		#if encounter.sprite == null:
			#type_color_rect.color = Color.WHITE
		#else:
			#type_color_rect.color = type2color(encounter.type)

func type2color (encounter_type : Encounter.Type) -> Color :
	match encounter_type:
		Encounter.Type.PASSIVE:
			return Color.GREEN
		Encounter.Type.AGRESSIVE:
			return Color.RED
		Encounter.Type.TARGET:
			return Color.DEEP_SKY_BLUE
	return Color.BLACK
