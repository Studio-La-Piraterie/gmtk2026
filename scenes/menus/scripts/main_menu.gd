extends Control
class_name MainMenu

@onready var start: Button = %Start

func _ready() -> void:
	start.pressed.connect(GameManager.change_game_scene.bind(GameManager.GameState.GAME))
