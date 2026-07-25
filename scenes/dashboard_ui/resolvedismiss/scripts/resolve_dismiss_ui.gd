extends Control
class_name ResolveDissmiss

@export var engage_btn: Button = null
@export var ok_btn: Button = null
@export var ctrl_btn: Button = null
@export var ready_btn: Button = null

@export var ok_diode: ColorRect = null
@export var ctrl_diode: ColorRect = null
@export var ready_diode: ColorRect = null

@export var dismiss_btn: Button = null
@export var kill_btn: Button = null

var resolve_machine_state : ResolveMachineState = ResolveMachineState.NONE :
	set = set_state

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
	if new_state == ResolveMachineState.OK_PRESSED && resolve_machine_state>new_state:
		return
	if new_state == ResolveMachineState.CTRL_PRESSED && resolve_machine_state>new_state:
		return
	if new_state == ResolveMachineState.READY_PRESSED && resolve_machine_state>new_state:
		return
	if new_state == ResolveMachineState.ENGAGE_SWITCHED && resolve_machine_state>=new_state:
		new_state = ResolveMachineState.ENCOUNTER_PRESENT
		
	resolve_machine_state = new_state

func update_resolve_machine_ui(new_state : ResolveMachineState)->void:
	if new_state == ResolveMachineState.NONE: return
	engage_btn.disabled = new_state < ResolveMachineState.ENCOUNTER_PRESENT
	ok_btn.disabled = new_state < ResolveMachineState.ENGAGE_SWITCHED
	ok_diode.color = Color.RED if new_state < ResolveMachineState.OK_PRESSED else Color.GREEN  
	ctrl_btn.disabled = new_state < ResolveMachineState.OK_PRESSED
	ctrl_diode.color = Color.RED if new_state < ResolveMachineState.CTRL_PRESSED else Color.GREEN  
	ready_btn.disabled = new_state < ResolveMachineState.CTRL_PRESSED
	ready_diode.color = Color.RED if new_state < ResolveMachineState.READY_PRESSED else Color.GREEN  
	kill_btn.disabled = new_state < ResolveMachineState.READY_PRESSED
	dismiss_btn.disabled = new_state < ResolveMachineState.ENCOUNTER_PRESENT
