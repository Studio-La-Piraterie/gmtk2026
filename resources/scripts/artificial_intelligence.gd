class_name ArtificialIntelligence extends Resource

enum Emotion {WORRIED, ANGRY, SAD, NEUTRAL, SURPRISED, CONFIDENT, GRATEFUL, HAPPY, HAPPY_IN_LOVE, IN_LOVE}

const AI_FACE : Dictionary = {
	Emotion.WORRIED: "",
	Emotion.ANGRY: "",
	Emotion.SAD: "",
	Emotion.NEUTRAL: "",
	Emotion.SURPRISED : "",
	Emotion.CONFIDENT : "",
	Emotion.GRATEFUL : "",
	Emotion.HAPPY : "",
	Emotion.HAPPY_IN_LOVE : "",
	Emotion.IN_LOVE : ""
}

#@export var emotion = Emotion.NEUTRAL
#@export var sprite : Texture2D = AI_FACE[self.emotion]
@export var sprite : Texture2D = null
#@export var discussion : Array[String]
@export var pair : Dictionary[String, Emotion]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
