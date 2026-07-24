class_name MainUI extends Control

@export var engage_btn: Button = Button.new()
@export var ok_btn: Button = Button.new()
@export var ctrl_btn: Button = Button.new()
@export var ready_btn: Button = Button.new()

@export var ok_diode: ColorRect = ColorRect.new()
@export var ctrl_diode: ColorRect = ColorRect.new()
@export var ready_diode: ColorRect = ColorRect.new()

@export var dismiss_btn: Button = Button.new()
@export var kill_btn: Button = Button.new()

@onready var main_countdown_label: Label = %MainCountdownLabel
@onready var lucarne: TextureRect = %Lucarne
@onready var reponse: Label = %Reponse
@onready var description: Label = %Description
@onready var wave_form: Label = %WaveForm
@export var type_color_rect: ColorRect = null

enum State {NONE = -255,
			NO_ENCOUNTER = 0,
			ENCOUNTER_PRESENT = 1,
			ENGAGE_SWITCHED = 2,
			OK_PRESSED = 3, 
			CTRL_PRESSED = 4,
			READY_PRESSED = 5}

var ui_state : State = State.NONE :
	set = set_state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_encounter(Encounter.new())
	set_state(State.NO_ENCOUNTER)
	engage_btn.pressed.connect(set_state.bind(State.ENGAGE_SWITCHED))
	ok_btn.pressed.connect(set_state.bind(State.OK_PRESSED))
	ctrl_btn.pressed.connect(set_state.bind(State.CTRL_PRESSED))
	ready_btn.pressed.connect(set_state.bind(State.READY_PRESSED))
	
func update_main_countdown(time_left : float) -> void:
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	main_countdown_label.text = "%02d:%02d" % [minute,second]

func set_encounter(encounter : Encounter) -> void:

	if not is_node_ready() :
		return
		
	if encounter == null:
		encounter = Encounter.new()
	
	lucarne.texture = encounter.sprite
	reponse.text = "Reponse:" + encounter.response
	description.text = "Description:" + encounter.description
	wave_form.text = "Wave Form:" + str(encounter.wave_form)
	if type_color_rect != null:
		type_color_rect.color = type2color(encounter.type)

func set_state(new_state : State) ->void:
	if new_state == State.OK_PRESSED && ui_state>new_state:
		return
	if new_state == State.CTRL_PRESSED && ui_state>new_state:
		return
	if new_state == State.READY_PRESSED && ui_state>new_state:
		return
	if new_state == State.ENGAGE_SWITCHED && ui_state>=new_state:
		new_state = State.ENCOUNTER_PRESENT
	
	ui_state = new_state
	engage_btn.disabled = ui_state < State.ENCOUNTER_PRESENT
	ok_btn.disabled = ui_state < State.ENGAGE_SWITCHED
	ok_diode.color = Color.RED if ui_state < State.OK_PRESSED else Color.GREEN  
	ctrl_btn.disabled = ui_state < State.OK_PRESSED
	ctrl_diode.color = Color.RED if ui_state < State.CTRL_PRESSED else Color.GREEN  
	ready_btn.disabled = ui_state < State.CTRL_PRESSED
	ready_diode.color = Color.RED if ui_state < State.READY_PRESSED else Color.GREEN  
	kill_btn.disabled = ui_state < State.READY_PRESSED
	dismiss_btn.disabled = ui_state < State.ENCOUNTER_PRESENT

func type2color (encounter_type : Encounter.Type) -> Color :
	match encounter_type:
		Encounter.Type.PASSIVE:
			return Color.GREEN
		Encounter.Type.AGRESSIVE:
			return Color.RED
		Encounter.Type.TARGET:
			return Color.DEEP_SKY_BLUE
	return Color.BLACK
