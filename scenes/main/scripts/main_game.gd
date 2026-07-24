class_name MainGame extends Node

@export var main_ui : MainUI = MainUI.new()

@export var timer_before_new_encounter : Timer = Timer.new()
@export var encounter_countdown : Timer = Timer.new()
@export var main_countdown : Timer = Timer.new()

var encounter_manager := EncounterManager.new()

enum GameOverType {TIME_UP, PACIFIC_VICTORY, NEUTRAL_VICTORY, AGGRESSIVE_VICTORY}

signal game_over(game_over_type : GameOverType)

var _current_encounter : Encounter = null :
	set(new_encounter):
		_current_encounter = new_encounter
		if main_ui != null:
			main_ui.set_encounter(_current_encounter)

func _ready() -> void:
	add_child(encounter_manager)
	
	main_countdown.start()
	timer_before_new_encounter.start()
	
	timer_before_new_encounter.timeout.connect(_go_to_next_encounter)
	encounter_countdown.timeout.connect(_dismiss_encounter)
	main_ui.dismiss_btn.pressed.connect(_dismiss_encounter)
	main_ui.kill_btn.pressed.connect(_kill_encounter)
	
	main_countdown.timeout.connect(emit_game_over)

func _physics_process(_delta: float) -> void:
	main_ui.update_main_countdown(main_countdown.time_left)

func _go_to_next_encounter() -> void:	
	_current_encounter = encounter_manager.get_new_encounter()
	if _current_encounter == null:
		return

	main_ui.ui_state = MainUI.State.ENCOUNTER_PRESENT
	timer_before_new_encounter.stop()
	encounter_countdown.start()
	
func _dismiss_encounter() -> void :
	_resolve_encounter(false)

func _kill_encounter() -> void :
	_resolve_encounter(true)
	
func _resolve_encounter(killed : bool) -> void :
	if _current_encounter == null:
		return
		
	if killed and _current_encounter.type == Encounter.Type.TARGET:
		encounter_manager.amount_target_killed+=1
		
	encounter_manager.available_encounters.erase(_current_encounter)
	
	var new_main_countdown_time := main_countdown.time_left + _current_encounter.get_encounter_result(killed)
	main_countdown.start(new_main_countdown_time) 
	
	_current_encounter = null
	main_ui.ui_state = MainUI.State.NO_ENCOUNTER
	
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
