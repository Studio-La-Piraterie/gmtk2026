class_name Encounter extends Resource

enum Type {PASSIVE,AGRESSIVE,TARGET}

@export var type : Type = Type.PASSIVE
@export var sprite : Texture2D = null
@export var description : String = ""
@export var wave_form : int = 0
@export var response : String = ""
