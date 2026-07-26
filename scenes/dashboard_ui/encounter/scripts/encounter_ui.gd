extends Control
class_name EncounterUI

@export var lucarne: Control
@export var encounter_sprite: AnimatedSprite2D
@export var description: Label


func update_encounter_ui(encounter :  Encounter)->void:
	if encounter == null:
		encounter = Encounter.new()
	
	encounter_sprite.sprite_frames = encounter.sprite
	encounter_sprite.play("default")
	
	description.text = tr(encounter.description)
