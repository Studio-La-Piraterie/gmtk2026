class_name ArtificialIntelligence extends Resource

enum Emotion {HAPPY, NEUTRAL, SAD}

@export var emotion = Emotion.NEUTRAL
@export var sprite : Texture2D = null
@export var discussion : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
