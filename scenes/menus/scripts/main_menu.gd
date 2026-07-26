extends Control
class_name MainMenu

@onready var start: BaseButton = $AnimBackground/Start
@onready var quit: BaseButton = $AnimBackground/Start2
@onready var language: BaseButton = $AnimBackground/Language
@onready var credits: BaseButton = $AnimBackground/Credits

func _ready() -> void:
	start.pressed.connect(start_game)

func start_game():
	var fade_t : Tween = create_tween()
	fade_t.tween_property(self,"modulate",Color.BLACK,1.5)
	await fade_t.finished
	GameManager.change_game_scene(GameManager.GameState.GAME)
