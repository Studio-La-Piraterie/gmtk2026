class_name AI extends Node

@onready var AI_face = $TerminalContainer/AIFaceContainer/AIFace
@onready var AI_text = $TerminalContainer/AITextContainer/AIText

@export var discussions : Dictionary[String, ArtificialIntelligence]
#@export var AI_happy : ArtificialIntelligence
#@export var AI_neutral : ArtificialIntelligence
#@export var AI_sad : ArtificialIntelligence

@export var discussion_order : Array[ArtificialIntelligence]

@export var character_update_time : float = 0.09
@export var character_displayed : int = 3
@export var time_before_next_ai_message : float = 4.0

enum Emotion {WORRIED, ANGRY, SAD, NEUTRAL, SURPRISED, CONFIDENT, GRATEFUL, HAPPY, HAPPY_IN_LOVE, IN_LOVE}

const AI_FACE : Dictionary = {
	Emotion.WORRIED: preload("res://assets/images/LAYA/laya_human_emotion_variant/worried.png"),
	Emotion.ANGRY: preload("res://assets/images/LAYA/laya_human_emotion_variant/angry.png"),
	Emotion.SAD: preload("res://assets/images/LAYA/laya_human_emotion_variant/sad.png"),
	Emotion.NEUTRAL: preload("res://assets/images/LAYA/laya_human_emotion_variant/neutral.png"),
	Emotion.SURPRISED : preload("res://assets/images/LAYA/laya_human_emotion_variant/surprised.png"),
	Emotion.CONFIDENT : preload("res://assets/images/LAYA/laya_human_emotion_variant/happy.png"), #Don't have confident so I put happy
	Emotion.GRATEFUL : preload("res://assets/images/LAYA/laya_human_emotion_variant/grateful.png"),
	Emotion.HAPPY : preload("res://assets/images/LAYA/laya_human_emotion_variant/happy.png"),
	Emotion.HAPPY_IN_LOVE : preload("res://assets/images/LAYA/laya_human_emotion_variant/hapilly_inlove.png"),
	Emotion.IN_LOVE : preload("res://assets/images/LAYA/laya_human_emotion_variant/in_love.png")
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_terminal(discussions["SELF_DESTRUCTION_LAYA"])
	pass # Replace with function body.

func update_terminal(ai : ArtificialIntelligence) -> void:
	if ai == null :
		return
	
	#update_AI_face(ai.sprite)
	for key in ai.pair:
		await update_AI_face(AI_FACE[ai.pair[key]])
		await update_AI_text(tr(key), character_update_time, character_displayed)
		await get_tree().create_timer(time_before_next_ai_message).timeout

## Update the face of the AI on the terminal
func update_AI_face(sprite : Texture2D) -> void:
	AI_face.texture = sprite

## Update the AI discussion on terminal
## [b]update_time[/b] is the frequency when new characters are displayed
## [b]characters_displayed[/b] is the number of characters displayed each time
func update_AI_text(discussion : String, update_time: float, characters_displayed: int) -> void:
	clear_AI_text()
	AI_text.add_text(discussion)
	while (AI_text.visible_characters < discussion.length()):
		AI_text.visible_characters += characters_displayed
		await get_tree().create_timer(update_time).timeout

## Clear the AI terminal
func clear_AI_text() -> void:
	AI_text.visible_characters = 0
	AI_text.clear()
	
