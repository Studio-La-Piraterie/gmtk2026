class_name MainGame extends Node

@export var dismiss_btn: Button = Button.new()
@export var kill_btn: Button = Button.new()

@export var main_ui : MainUI = MainUI.new()

@export var timer_before_new_encounter : Timer = Timer.new()
@export var encounter_countdown : Timer = Timer.new()
@export var main_countdown : Timer = Timer.new()

var _current_encounter : Encounter = null :
	set(new_encounter):
		_current_encounter = new_encounter
		if main_ui != null:
			main_ui.set_encounter(_current_encounter)

func _ready() -> void:
	main_countdown.start()
	kill_btn.disabled = true
	dismiss_btn.disabled = true
	timer_before_new_encounter.start()
	timer_before_new_encounter.timeout.connect(_go_to_next_encounter)
	encounter_countdown.timeout.connect(_dismiss_encounter)
	dismiss_btn.pressed.connect(_dismiss_encounter)
	kill_btn.pressed.connect(_kill_encounter)

func _physics_process(_delta: float) -> void:
	main_ui.update_main_countdown(main_countdown.time_left)

func _go_to_next_encounter() -> void:
	
	dismiss_btn.disabled = false
	kill_btn.disabled = false
	
	_current_encounter = EncounterDispenser.get_new_encounter()
	
	timer_before_new_encounter.stop()
	encounter_countdown.start()
	
func _dismiss_encounter() -> void :
	_resolve_encounter(false)

func _kill_encounter() -> void :
	_resolve_encounter(true)
	
func _resolve_encounter(killed : bool) -> void :
	if _current_encounter == null:
		return
	
	dismiss_btn.disabled = true
	kill_btn.disabled = true
	
	var new_main_countdown_time := main_countdown.time_left + _current_encounter.get_encounter_result(killed)
	main_countdown.start(new_main_countdown_time) 
	
	_current_encounter = null
	timer_before_new_encounter.start()
	encounter_countdown.stop()
	

 
