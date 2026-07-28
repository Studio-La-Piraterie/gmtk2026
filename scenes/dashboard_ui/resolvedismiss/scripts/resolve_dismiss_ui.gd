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

@export var buttons_sfx: AudioStreamPlayer
@export var engage_switch_on_sfx: AudioStreamPlayer
@export var engage_switch_off_sfx: AudioStreamPlayer
@export var diode_on_sfx: AudioStreamPlayer
@export var resolve_dismiss_on_sfx: AudioStreamPlayer
@export var dismiss_button_sfx: AudioStreamPlayer
@export var resolve_button_sfx: AudioStreamPlayer

var tween_buttons_sfx: Tween
var tween_engage_sfx: Tween
var tween_diode_sfx: Tween
var tween_resolvedismiss_diode_sfx: Tween
var tween_resolvedismiss_button_sfx: Tween


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
	
	dismiss_btn.pressed.connect(func(): SFXManager.play_sfx(resolve_button_sfx, tween_resolvedismiss_button_sfx))
	kill_btn.pressed.connect(func(): SFXManager.play_sfx(dismiss_button_sfx, tween_resolvedismiss_button_sfx))
	
	if get_tree().current_scene == self: # when launching the scene for ui testing
		set_state(ResolveMachineState.ENCOUNTER_PRESENT)
	else: set_state(ResolveMachineState.NO_ENCOUNTER)


func set_state(new_state : ResolveMachineState) ->void:
	
	match new_state:
		ResolveMachineState.ENGAGE_SWITCHED:
			if resolve_machine_state>=new_state:
				resolve_machine_state = ResolveMachineState.ENCOUNTER_PRESENT
				SFXManager.play_sfx(engage_switch_on_sfx, tween_engage_sfx)
			else :
				resolve_machine_state = new_state
				SFXManager.play_sfx(engage_switch_off_sfx, tween_engage_sfx)
				await get_tree().create_timer(diode_turn_on_wait_time).timeout
				SFXManager.play_sfx(diode_on_sfx, tween_diode_sfx)
				SFXManager.play_sfx(resolve_dismiss_on_sfx, tween_resolvedismiss_diode_sfx)

		ResolveMachineState.OK_PRESSED:
			if resolve_machine_state>new_state:
				return
			if resolve_machine_state == ResolveMachineState.ENGAGE_SWITCHED:
				SFXManager.play_sfx(buttons_sfx, tween_buttons_sfx)
				resolve_machine_state = new_state
				await get_tree().create_timer(diode_turn_on_wait_time).timeout
				SFXManager.play_sfx(diode_on_sfx, tween_diode_sfx)
		
		ResolveMachineState.CTRL_PRESSED:
			if resolve_machine_state>new_state:
				return
			if resolve_machine_state == ResolveMachineState.OK_PRESSED:
				SFXManager.play_sfx(buttons_sfx, tween_buttons_sfx)
				resolve_machine_state = new_state
				await get_tree().create_timer(diode_turn_on_wait_time).timeout
				SFXManager.play_sfx(diode_on_sfx, tween_diode_sfx)
		
		ResolveMachineState.READY_PRESSED:
			if resolve_machine_state>new_state:
				return
			if resolve_machine_state == ResolveMachineState.CTRL_PRESSED:
				SFXManager.play_sfx(buttons_sfx, tween_buttons_sfx)
				resolve_machine_state = new_state
				await get_tree().create_timer(diode_turn_on_wait_time).timeout
				SFXManager.play_sfx(resolve_dismiss_on_sfx, tween_resolvedismiss_diode_sfx)
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
	
	
