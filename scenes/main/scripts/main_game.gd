class_name MainGame extends Node

var _encounter_present : bool = false
var _current_encounter : Encounter = null

@export var dismiss_btn: Button = Button.new()
@export var kill_btn: Button = Button.new()

@export var main_ui : MainUI = MainUI.new()
@export var main_countdown : Timer = Timer.new()
@export var time_to_next_encounter : float = 5#s
@export var ecounter_time : float = 10

func _ready() -> void:
	main_countdown.start()


func _physics_process(_delta: float) -> void:
	main_ui.update_main_countdown(main_countdown.time_left)

func dismiss_encounter() -> void :
	dismiss_btn.disabled = true
	kill_btn.disabled = true

func kill_encounter() -> void :
	dismiss_btn.disabled = true
	kill_btn.disabled = true
	
func check_encounter_and_set_main_countdown(killed : bool) -> void :
	if _current_encounter == null:
		return
	
	var new_main_countdown_time := main_countdown.time_left + _current_encounter.get_encounter_result(killed)
	main_countdown.start(new_main_countdown_time) 
	

 
