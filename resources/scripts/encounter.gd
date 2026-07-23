class_name Encounter extends Resource

const ENCOUNTER_RESULTS : Dictionary = {
	Type.PASSIVE : {
		true : -15.0,
		false : 0.0
	},
	Type.AGRESSIVE: {
		true : 15.0,
		false : -10.0
	},
	Type.TARGET: {
		true : 60.0,
		false : 0.0
	}
}

enum Type {PASSIVE,AGRESSIVE,TARGET}

@export var type : Type = Type.PASSIVE
@export var sprite : Texture2D = null
@export var description : String = ""
@export var wave_form : int = 0
@export var response : String = ""

func get_encounter_result(killed : bool) -> float :
	return ENCOUNTER_RESULTS[self.type][killed]
