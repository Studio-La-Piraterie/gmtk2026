class_name DashboardUI extends Control

@export_group("Dashboard Sections")
@export var resolve_dismiss_ui: ResolveDissmiss
@export var encounter_ui: EncounterUI
@export var unstable_cable : UnstableCable
@export var oscilloscope : Oscilloscope

@export var order_terminal : OrderTerminal
@export var ai_chat : AI

@onready var main_countdown_display: MainCountdown = %MainCountdownLabel
@onready var encounter_audio_player: AudioStreamPlayer = $EncounterAudioPlayer

var current_target : Encounter = null :
	set = set_target
var currently_displayed_encounter : Encounter = null :
	set = set_encounter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_encounter(null)
	set_target(current_target)
	unstable_cable.failed.connect(unstable_cable_fail)
	unstable_cable.restored.connect(unstable_cable_restored)

func set_target(new_target : Encounter) ->void:
	if not is_node_ready() :
		return
	if new_target == null:
		new_target = Encounter.new()
	
	current_target = new_target
	order_terminal.set_encounter_order(current_target)
	
	
func set_encounter(encounter : Encounter) -> void:
	if not is_node_ready() :
		return

	if encounter == null:
		update_resolve_machine_ui(ResolveDissmiss.ResolveMachineState.NO_ENCOUNTER)
		encounter = Encounter.new()
	else:
		update_resolve_machine_ui(ResolveDissmiss.ResolveMachineState.ENCOUNTER_PRESENT)
	
	currently_displayed_encounter = encounter
	play_encounter_audio(encounter.audio_stream)
	update_oscilloscope_ui(encounter)
	if not unstable_cable.hasFailed:
		update_encounter_ui(encounter)

func update_ai_chat_target():
	ai_chat.update_terminal(ai_chat.discussion_order.pop_back())

func update_oscilloscope_ui(encounter : Encounter) ->void :
	oscilloscope.update(encounter.oscillo_gif, encounter.min_oscillo_val, encounter.max_oscillo_val)

func update_encounter_ui(encounter :  Encounter):
	encounter_ui.update_encounter_ui(encounter)

func update_resolve_machine_ui(state : ResolveDissmiss.ResolveMachineState):
	resolve_dismiss_ui.set_state(state)

func update_main_countdown(time_left : float) ->void:
	if not main_countdown_display.is_skipping:
		main_countdown_display.displayed_time=time_left

func play_encounter_audio(encounter_audio : AudioStream) -> void:
	encounter_audio_player.stream = encounter_audio
	encounter_audio_player.play()

func unstable_cable_fail()->void:
	update_encounter_ui(Encounter.new())
	resolve_dismiss_ui.disable()
	oscilloscope.disable()
	order_terminal.disable()
	encounter_audio_player.stream_paused = true
	
func unstable_cable_restored()->void:
	update_encounter_ui(currently_displayed_encounter)
	resolve_dismiss_ui.enable()
	oscilloscope.enable()
	order_terminal.enable()
	encounter_audio_player.stream_paused = false
