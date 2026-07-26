extends Control
class_name ResolveDissmiss

const DIODE_OFF = preload("res://assets/images/dashboard/diode_off_final.png")
const DIODE_ON = preload("res://assets/images/dashboard/diode_on_final.png")

@export var engage_btn: TextureButton = null
@export var ok_btn: TextureButton = null
@export var ctrl_btn: TextureButton = null
@export var ready_btn: TextureButton = null

@export var ok_diode: TextureRect = null
@export var ctrl_diode: TextureRect = null
@export var ready_diode: TextureRect = null

@export var dismiss_btn: TextureButton = null
@export var kill_btn: TextureButton = null

var resolve_machine_state : ResolveMachineState = ResolveMachineState.NONE :
	set = set_state

var disabled := false
var diode_turn_on_wait_time : float = 1.2

enum ResolveMachineState {
	NONE = -255,
	NO_ENCOUNTER = 0,
	ENCOUNTER_PRESENT = 1,
	ENGAGE_SWITCHED = 2,
	OK_PRESSED = 3, 
	CTRL_PRESSED = 4,
	READY_PRESSED = 5
}

func _ready():
	engage_btn.pressed.connect(set_state.bind(ResolveMachineState.ENGAGE_SWITCHED))
	ok_btn.pressed.connect(set_state.bind(ResolveMachineState.OK_PRESSED))
	ctrl_btn.pressed.connect(set_state.bind(ResolveMachineState.CTRL_PRESSED))
	ready_btn.pressed.connect(set_state.bind(ResolveMachineState.READY_PRESSED))
	
	dismiss_btn.pressed.connect(func(): SignalBus.resolve_encounter.emit(false))
	kill_btn.pressed.connect(func(): SignalBus.resolve_encounter.emit(true))
	
	set_state(ResolveMachineState.NO_ENCOUNTER)


func set_state(new_state : ResolveMachineState) ->void:
	
	match new_state:
		ResolveMachineState.ENGAGE_SWITCHED:
			if resolve_machine_state>=new_state:
				resolve_machine_state = ResolveMachineState.ENCOUNTER_PRESENT
			else :
				resolve_machine_state = new_state
				await get_tree().create_timer(diode_turn_on_wait_time).timeout

		ResolveMachineState.OK_PRESSED:
			if resolve_machine_state>new_state:
				return
			if resolve_machine_state == ResolveMachineState.ENGAGE_SWITCHED:
				resolve_machine_state = new_state
				await get_tree().create_timer(diode_turn_on_wait_time).timeout
		
		ResolveMachineState.CTRL_PRESSED:
			if resolve_machine_state>new_state:
				return
			if resolve_machine_state == ResolveMachineState.OK_PRESSED:
				resolve_machine_state = new_state
				await get_tree().create_timer(diode_turn_on_wait_time).timeout
		
		ResolveMachineState.READY_PRESSED:
			if resolve_machine_state>new_state:
				return
			if resolve_machine_state == ResolveMachineState.CTRL_PRESSED:
				resolve_machine_state = new_state
				await get_tree().create_timer(diode_turn_on_wait_time).timeout
		_:
			resolve_machine_state = new_state

	if not disabled:
		_update_resolve_machine_ui(resolve_machine_state)

func _update_resolve_machine_ui(new_state : ResolveMachineState)->void:
	if new_state == ResolveMachineState.NONE: return
	
	engage_btn.disabled = new_state < ResolveMachineState.ENCOUNTER_PRESENT
	ok_btn.disabled = new_state < ResolveMachineState.ENGAGE_SWITCHED
	ok_diode.texture = DIODE_OFF  if new_state < ResolveMachineState.ENGAGE_SWITCHED else DIODE_ON  
	ctrl_btn.disabled = new_state < ResolveMachineState.OK_PRESSED
	ctrl_diode.texture = DIODE_OFF  if new_state < ResolveMachineState.OK_PRESSED else DIODE_ON  
	ready_btn.disabled = new_state < ResolveMachineState.CTRL_PRESSED
	ready_diode.texture = DIODE_OFF  if new_state < ResolveMachineState.CTRL_PRESSED else DIODE_ON  
	kill_btn.disabled = new_state < ResolveMachineState.READY_PRESSED
	dismiss_btn.disabled = new_state < ResolveMachineState.ENGAGE_SWITCHED

func disable() -> void:
	disabled = true
	_update_resolve_machine_ui(ResolveMachineState.NO_ENCOUNTER)

func enable() -> void:
	disabled = false
	_update_resolve_machine_ui(resolve_machine_state)
