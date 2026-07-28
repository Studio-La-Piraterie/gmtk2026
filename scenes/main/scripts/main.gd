class_name MainGame extends Node

@export var dashboard_ui : DashboardUI
@export var timer_before_new_encounter : Timer
@export var encounter_countdown : Timer
@export var main_countdown : Timer
@export var pause_menu: PauseMenu 

var encounter_manager := EncounterManager.new()

enum GameOverType {TIME_UP, PACIFIC_VICTORY, NEUTRAL_VICTORY, AGGRESSIVE_VICTORY}

signal game_over(game_over_type : GameOverType)

func _on_game_over(game_over_type : GameOverType):
	main_countdown.stop()
	var ai_chat_text : String 
	match game_over_type:
		GameOverType.TIME_UP:
			"GAME_OVER_END_LAYA"
		GameOverType.PACIFIC_VICTORY:
			"PACIFIST_END_LAYA"
		GameOverType.NEUTRAL_VICTORY:
			"FAILED_END_LAYA"
		GameOverType.AGGRESSIVE_VICTORY:
			"END_GEN_LAYA"
		
	dashboard_ui.ai_chat.update_terminal(dashboard_ui.ai_chat.discussions[ai_chat_text])
	await get_tree().create_timer(7).timeout
	
	var fade_t : Tween = create_tween()
	fade_t.tween_property(self,"modulate",Color.BLACK,1.5)
	await fade_t.finished
	GameManager.change_game_scene(GameManager.GameState.MAIN_MENU)

	
var _current_encounter : Encounter = null :
	set = _set_encounter

var _current_target : Encounter = null :
	set = _set_target

func _ready() -> void:
	
	_set_target(encounter_manager.get_current_target())

	pause_menu.resume_game()
	add_child(encounter_manager)
	
	main_countdown.start()
	timer_before_new_encounter.start()
	
	timer_before_new_encounter.timeout.connect(_go_to_next_encounter)
	encounter_countdown.timeout.connect(_dismiss_encounter)
	main_countdown.timeout.connect(emit_game_over)
	game_over.connect(_on_game_over)
	encounter_manager.new_target_update_order.connect(dashboard_ui.update_ai_chat_target)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_unpause") && not get_tree().is_paused():
		get_viewport().set_input_as_handled()
		pause_menu.pause_game()

func _process(_delta: float) -> void:
	dashboard_ui.update_main_countdown(main_countdown.time_left)

func _set_target(new_target : Encounter):
	
	_current_target = new_target
	if dashboard_ui != null:
		dashboard_ui.set_target(_current_target)

func _set_encounter(new_encounter : Encounter):
	_current_encounter = new_encounter
	if dashboard_ui != null:
		dashboard_ui.set_encounter(_current_encounter)

func _go_to_next_encounter() -> void:	
	_current_encounter = encounter_manager.get_new_encounter()
	if _current_encounter == null:
		return
		
	AudioManager.reduce_bgm_volume()
	AudioManager.play_encounter_noise()
	
	timer_before_new_encounter.stop()
	encounter_countdown.start()
	
func _dismiss_encounter() -> void :
	_resolve_encounter(false)

func _kill_encounter() -> void :
	_resolve_encounter(true)
	
func _resolve_encounter(killed : bool) -> void :
	if _current_encounter == null:
		return
		
	AudioManager.stop_encounter_noise()
	
	encounter_manager.encounter_processed(_current_encounter,killed)
	var encounter_result_time : float = _current_encounter.get_encounter_result(killed)
	var new_main_countdown_time := main_countdown.time_left + encounter_result_time
	
	_set_encounter(null)
	_set_target(encounter_manager.get_current_target())

	dashboard_ui.resolve_dismiss_ui.resolve_machine_state = ResolveDissmiss.ResolveMachineState.NO_ENCOUNTER
	dashboard_ui.main_countdown_display.animate_time_skip(main_countdown.time_left,new_main_countdown_time)
	
	main_countdown.start(new_main_countdown_time) 

	if not encounter_manager.are_encounter_remaining():
		emit_game_over()
	
	timer_before_new_encounter.start()
	encounter_countdown.stop()

func emit_game_over()->void:
	game_over.emit(check_end_game_condition())

func check_end_game_condition()->GameOverType:
	if main_countdown.time_left == 0:
		return GameOverType.TIME_UP
	
	if encounter_manager.are_all_target_dead():
		return GameOverType.AGGRESSIVE_VICTORY
	
	if encounter_manager.are_any_target_dead():
		return GameOverType.NEUTRAL_VICTORY
	
	return GameOverType.PACIFIC_VICTORY
	

func _on_dismiss_btn_pressed():
	_dismiss_encounter()

func _on_kill_btn_pressed():
	_kill_encounter()
