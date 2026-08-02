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

var _resolve_machine_state : ResolveMachineState = ResolveMachineState.NONE
var disabled := false
var diode_turn_on_wait_time : float = 1.2
var diode_turn_on_timeout_check : float

signal dismiss_encounter
signal kill_encounter

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
	engage_btn.toggled.connect(_on_engaged_toggled)
	ok_btn.toggled.connect(_on_ok_btn_toggled)
	ctrl_btn.toggled.connect(_on_ctrl_btn_toggled)
	ready_btn.toggled.connect(_on_ready_btn_toggled)
	
	dismiss_btn.pressed.connect(_dissmiss_encounter)
	kill_btn.pressed.connect(_resolve_encounter)
	
	if get_tree().current_scene == self: # when launching the scene for ui testing
		set_state(ResolveMachineState.ENCOUNTER_PRESENT)
	else: set_state(ResolveMachineState.NO_ENCOUNTER)

func _resolve_encounter():
	SFXManager.play_sfx(resolve_button_sfx, tween_resolvedismiss_button_sfx)
	kill_encounter.emit()
	
func _dissmiss_encounter():
	SFXManager.play_sfx(dismiss_button_sfx, tween_resolvedismiss_button_sfx)
	dismiss_encounter.emit()

func set_state(new_state : ResolveMachineState, update_ui : bool = true) ->void:
	_resolve_machine_state = new_state
	if update_ui:
		_update_resolve_machine_ui()

func _update_resolve_machine_ui()->void:
	if _resolve_machine_state == ResolveMachineState.NONE: return
	
	engage_btn.set_pressed_no_signal(_resolve_machine_state >= ResolveMachineState.ENGAGE_SWITCHED && not disabled)
	engage_btn.disabled = _resolve_machine_state < ResolveMachineState.ENCOUNTER_PRESENT || disabled
	
	ok_btn.set_pressed_no_signal(_resolve_machine_state >= ResolveMachineState.OK_PRESSED && not disabled)
	ok_btn.disabled = _resolve_machine_state < ResolveMachineState.ENGAGE_SWITCHED || disabled
	ok_diode.texture = DIODE_ON if (_resolve_machine_state >= ResolveMachineState.ENGAGE_SWITCHED && not disabled) else DIODE_OFF  
	
	ctrl_btn.set_pressed_no_signal(_resolve_machine_state >= ResolveMachineState.CTRL_PRESSED && not disabled)
	ctrl_btn.disabled = _resolve_machine_state < ResolveMachineState.OK_PRESSED || disabled
	ctrl_diode.texture = DIODE_ON if (_resolve_machine_state >= ResolveMachineState.OK_PRESSED && not disabled) else DIODE_OFF  
	
	ready_btn.set_pressed_no_signal(_resolve_machine_state >= ResolveMachineState.READY_PRESSED && not disabled)
	ready_btn.disabled = _resolve_machine_state < ResolveMachineState.CTRL_PRESSED || disabled
	ready_diode.texture = DIODE_ON if (_resolve_machine_state >= ResolveMachineState.CTRL_PRESSED && not disabled) else DIODE_OFF  
	
	kill_btn.disabled = _resolve_machine_state < ResolveMachineState.READY_PRESSED || disabled
	dismiss_btn.disabled = _resolve_machine_state < ResolveMachineState.ENGAGE_SWITCHED || disabled

func disable() -> void:
	disabled = true
	_update_resolve_machine_ui()

func enable() -> void:
	disabled = false
	_update_resolve_machine_ui()

func _on_engaged_toggled(toggled_on : bool):
	var check = randf()
	diode_turn_on_timeout_check = check
	if toggled_on:
		SFXManager.play_sfx(engage_switch_on_sfx, tween_engage_sfx)
		set_state(ResolveMachineState.ENGAGE_SWITCHED,false)
		SFXManager.play_sfx(resolve_dismiss_on_sfx, tween_resolvedismiss_diode_sfx)
		await get_tree().create_timer(diode_turn_on_wait_time).timeout
		if check == diode_turn_on_timeout_check:
			_update_resolve_machine_ui()
			SFXManager.play_sfx(diode_on_sfx, tween_diode_sfx)
	else :
		set_state(ResolveMachineState.ENCOUNTER_PRESENT) 
		SFXManager.play_sfx(engage_switch_off_sfx, tween_engage_sfx)
	
func _on_ok_btn_toggled(toggled_on : bool):
	var check = randf()
	diode_turn_on_timeout_check = check
	if toggled_on:
		SFXManager.play_sfx(buttons_sfx, tween_buttons_sfx)
		set_state(ResolveMachineState.OK_PRESSED,false)
		await get_tree().create_timer(diode_turn_on_wait_time).timeout
		if check == diode_turn_on_timeout_check:
			_update_resolve_machine_ui()
			SFXManager.play_sfx(diode_on_sfx, tween_diode_sfx)
	else :
		set_state(ResolveMachineState.ENGAGE_SWITCHED)

func _on_ctrl_btn_toggled(toggled_on : bool):
	var check = randf()
	diode_turn_on_timeout_check = check
	if toggled_on:
		SFXManager.play_sfx(buttons_sfx, tween_buttons_sfx)
		set_state(ResolveMachineState.CTRL_PRESSED,false)
		await get_tree().create_timer(diode_turn_on_wait_time).timeout
		if check == diode_turn_on_timeout_check:
			_update_resolve_machine_ui()
			SFXManager.play_sfx(diode_on_sfx, tween_diode_sfx)
	else :
		set_state(ResolveMachineState.OK_PRESSED)
	
func _on_ready_btn_toggled(toggled_on : bool):
	var check = randf()
	diode_turn_on_timeout_check = check
	if toggled_on:
		SFXManager.play_sfx(buttons_sfx, tween_buttons_sfx)
		set_state(ResolveMachineState.READY_PRESSED,false)
		await get_tree().create_timer(diode_turn_on_wait_time).timeout
		if check == diode_turn_on_timeout_check:
			_update_resolve_machine_ui()
			SFXManager.play_sfx(diode_on_sfx, tween_diode_sfx)
	else :
		set_state(ResolveMachineState.CTRL_PRESSED)
