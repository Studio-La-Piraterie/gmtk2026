class_name MainUI extends Control

@export var engage_btn: Button = null
@export var ok_btn: Button = null
@export var ctrl_btn: Button = null
@export var ready_btn: Button = null

@export var ok_diode: ColorRect = null
@export var ctrl_diode: ColorRect = null
@export var ready_diode: ColorRect = null

@export var dismiss_btn: Button = null
@export var kill_btn: Button = null

@export var unstable_cable : UnstableCable = null

@onready var main_countdown_label: MainCountdown = %MainCountdownLabel
@onready var lucarne: TextureRect = %Lucarne
@onready var reponse: Label = %Reponse
@onready var description: Label = %Description
@onready var wave_form: Label = %WaveForm
@export var type_color_rect: ColorRect = null

enum ResolveMachineState {NONE = -255,
			NO_ENCOUNTER = 0,
			ENCOUNTER_PRESENT = 1,
			ENGAGE_SWITCHED = 2,
			OK_PRESSED = 3, 
			CTRL_PRESSED = 4,
			READY_PRESSED = 5}

var currently_displayed_encounter := Encounter.new() :
	set = set_encounter
var resolve_machine_state : ResolveMachineState = ResolveMachineState.NONE :
	set = set_state
	
var ui_save_when_unstable_cable_fail : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_encounter(Encounter.new())
	set_state(ResolveMachineState.NO_ENCOUNTER)
	
	engage_btn.pressed.connect(set_state.bind(ResolveMachineState.ENGAGE_SWITCHED))
	ok_btn.pressed.connect(set_state.bind(ResolveMachineState.OK_PRESSED))
	ctrl_btn.pressed.connect(set_state.bind(ResolveMachineState.CTRL_PRESSED))
	ready_btn.pressed.connect(set_state.bind(ResolveMachineState.READY_PRESSED))
	
	unstable_cable.failed.connect(unstable_cable_fail)
	unstable_cable.restored.connect(unstable_cable_restored)
	
func update_main_countdown(time_left : float) -> void:
	main_countdown_label.update_main_countdown(time_left)

func set_encounter(encounter : Encounter) -> void:
	if not is_node_ready() :
		return
		
	if encounter == null:
		encounter = Encounter.new()
	
	currently_displayed_encounter = encounter
	if not unstable_cable.hasFailed:
		update_encounter_ui(encounter)

func update_encounter_ui(encounter :  Encounter)->void:
	if encounter == null:
		encounter = Encounter.new()
	lucarne.texture = encounter.sprite
	reponse.text = "Reponse:" + encounter.response
	description.text = "Description:" + encounter.description
	wave_form.text = "Wave Form:" + str(encounter.wave_form)
	if type_color_rect != null:
		if encounter.sprite == null:
			type_color_rect.color = Color.WHITE
		else:
			type_color_rect.color = type2color(encounter.type)

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
	if not unstable_cable.hasFailed:
		update_resolve_machine_ui(resolve_machine_state)

func update_resolve_machine_ui(state : ResolveMachineState)->void:
	engage_btn.disabled = state < ResolveMachineState.ENCOUNTER_PRESENT
	ok_btn.disabled = state < ResolveMachineState.ENGAGE_SWITCHED
	ok_diode.color = Color.RED if state < ResolveMachineState.OK_PRESSED else Color.GREEN  
	ctrl_btn.disabled = state < ResolveMachineState.OK_PRESSED
	ctrl_diode.color = Color.RED if state < ResolveMachineState.CTRL_PRESSED else Color.GREEN  
	ready_btn.disabled = state < ResolveMachineState.CTRL_PRESSED
	ready_diode.color = Color.RED if state < ResolveMachineState.READY_PRESSED else Color.GREEN  
	kill_btn.disabled = state < ResolveMachineState.READY_PRESSED
	dismiss_btn.disabled = state < ResolveMachineState.ENCOUNTER_PRESENT

func unstable_cable_fail()->void:
	update_encounter_ui(Encounter.new())
	update_resolve_machine_ui(ResolveMachineState.NO_ENCOUNTER)

func unstable_cable_restored()->void:
	update_encounter_ui(currently_displayed_encounter)
	update_resolve_machine_ui(resolve_machine_state)

func type2color (encounter_type : Encounter.Type) -> Color :
	match encounter_type:
		Encounter.Type.PASSIVE:
			return Color.GREEN
		Encounter.Type.AGRESSIVE:
			return Color.RED
		Encounter.Type.TARGET:
			return Color.DEEP_SKY_BLUE
	return Color.BLACK
