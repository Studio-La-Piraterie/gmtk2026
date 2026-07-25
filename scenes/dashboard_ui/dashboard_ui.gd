class_name DashboardUI extends Control

@export_group("Dashboard Sections")
@export var resolve_dismiss_ui: ResolveDissmiss
@export var encounter_ui: EncounterUI
@export var unstable_cable : UnstableCable

@onready var main_countdown_display: MainCountdown = %MainCountdownLabel
@onready var encounter_audio_player: AudioStreamPlayer = $EncounterAudioPlayer

var currently_displayed_encounter : Encounter = null :
	set = set_encounter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_encounter(null)
	
	unstable_cable.failed.connect(unstable_cable_fail)
	unstable_cable.restored.connect(unstable_cable_restored)

func set_encounter(encounter : Encounter) -> void:
	if not is_node_ready() :
		return

	if encounter == null:
		resolve_dismiss_ui.set_state(ResolveDissmiss.ResolveMachineState.NO_ENCOUNTER)
		encounter = Encounter.new()
	else:
		resolve_dismiss_ui.set_state(ResolveDissmiss.ResolveMachineState.ENCOUNTER_PRESENT)
	
	currently_displayed_encounter = encounter
	if not unstable_cable.hasFailed:
		update_encounter_ui(encounter)
		
	
func update_encounter_ui(encounter :  Encounter):
	encounter_ui.update_encounter_ui(encounter)

func update_resolve_machine_ui(state : ResolveDissmiss.ResolveMachineState):
	resolve_dismiss_ui.update_resolve_machine_ui(state)

func update_main_countdown(time_left : float) ->void:
	if not main_countdown_display.is_skipping:
		main_countdown_display.displayed_time=time_left

func unstable_cable_fail()->void:
	update_encounter_ui(Encounter.new())
	resolve_dismiss_ui.disable()
	
func unstable_cable_restored()->void:
	update_encounter_ui(currently_displayed_encounter)
	resolve_dismiss_ui.enable()
