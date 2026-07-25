class_name AI extends Node

@onready var AI_face = $TerminalContainer/AIFaceContainer/AIFace
@onready var AI_text = $TerminalContainer/AITextContainer/AIText

@export var AI_happy : ArtificialIntelligence
@export var AI_neutral : ArtificialIntelligence
@export var AI_sad : ArtificialIntelligence

@export var character_update_time : float = 0.09
@export var character_displayed : int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_terminal(AI_neutral)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_terminal(ai : ArtificialIntelligence):
	update_AI_face(ai.sprite)
	update_AI_text(ai.discussion, character_update_time, character_displayed)

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
	
