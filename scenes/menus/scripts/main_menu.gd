extends Control
class_name MainMenu

@onready var start: BaseButton = $AnimBackground/StartButton
@onready var quit: BaseButton = $AnimBackground/QuitButtonBackground/QuitButton
@onready var language: BaseButton = $AnimBackground/LanguageButton
@onready var credits: BaseButton = $AnimBackground/CreditButton

func _ready() -> void:
	for button in [start, language,credits, quit]:
		button.mouse_entered.connect(button_hover.bind(button))
		button.mouse_exited.connect(button_unhover.bind(button))
	start.pressed.connect(start_game)
	quit.pressed.connect(quit_game)
	
	AudioManager.play_menu_bgm()
	
func start_game():
	var fade_t : Tween = create_tween()
	fade_t.tween_property(self,"modulate",Color.BLACK,1.5)
	fade_t.set_parallel(true).tween_property(AudioManager.menu_bgm, "volume_db", AudioManager.menu_bgm.volume_db - 5.0, 1.5)
	await fade_t.finished
	GameManager.change_game_scene(GameManager.GameState.GAME)
	
func quit_game()->void:
	if OS.get_name() == "Web":
		return
	
	var fade_t : Tween = create_tween()
	fade_t.tween_property(self,"modulate",Color.BLACK,1.5)
	await fade_t.finished
	get_tree().quit()
	
func button_hover(button : Button) -> void:
	button.text = button.text + "*"
	
func button_unhover(button : Button) -> void:
	button.text = button.text.trim_suffix("*")
