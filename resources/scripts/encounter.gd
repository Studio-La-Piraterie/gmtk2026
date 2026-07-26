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

@export_category("Encounter carac")
@export var type : Type = Type.PASSIVE
@export var sprite : SpriteFrames = null
@export var description : String = ""
@export var audio_stream : AudioStream = null
@export var oscillo_gif : GIFTexture = null

@export_category("Order carac")
@export var target_order : Array[String]
@export var show_oscillo : bool = false

var min_oscillo_val : float = 0.0
var max_oscillo_val : float = 0.0

func _init() -> void:
	var oscillo_range = randf_range(10.0,30.0)
	min_oscillo_val = randf_range(0.0,100.0-oscillo_range)
	max_oscillo_val = min_oscillo_val+oscillo_range

func get_encounter_result(killed : bool) -> float :
	return ENCOUNTER_RESULTS[self.type][killed]
