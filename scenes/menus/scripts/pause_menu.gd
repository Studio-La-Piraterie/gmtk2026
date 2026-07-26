extends Control
class_name PauseMenu

@onready var resume: BaseButton = %Resume
@onready var quit: BaseButton = %Quit
@onready var french: BaseButton = %French
@onready var english: BaseButton = %English

func _ready() -> void:
	resume.pressed.connect(resume_game)
	quit.pressed.connect(quit_game)
	french.pressed.connect(switch_translate.bind("fr"))
	english.pressed.connect(switch_translate.bind("en"))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_unpause") && get_tree().paused:
		get_viewport().set_input_as_handled()
		resume_game()

func resume_game():
	get_tree().paused = false
	hide()

func pause_game():
	get_tree().paused = true
	show()
	
func switch_translate(lang_code : String)->void :
	TranslationServer.set_locale(lang_code)

func quit_game()->void:
	if OS.get_name() == "Web":
		return
	
	var fade_t : Tween = create_tween()
	fade_t.tween_property(self,"modulate",Color.BLACK,1.5)
	await fade_t.finished
	get_tree().quit()
