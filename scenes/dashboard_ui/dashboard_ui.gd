class_name DashboardUI extends Control

@export_group("Dashboard Sections")
@export var resolve_dismiss_ui: ResolveDissmiss
@export var encounter_ui: EncounterUI
@export var unstable_cable : UnstableCable

@onready var main_countdown_label: Label = %MainCountdownLabel

var currently_displayed_encounter := Encounter.new() :
	set = set_encounter
	
var ui_save_when_unstable_cable_fail : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_encounter(Encounter.new())
	
	unstable_cable.failed.connect(unstable_cable_fail)
	unstable_cable.restored.connect(unstable_cable_restored)
	
func update_main_countdown(time_left : float) -> void:
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	main_countdown_label.text = "%02d:%02d" % [minute,second]

func set_encounter(encounter : Encounter) -> void:
	if not is_node_ready() :
		return
		
	if encounter == null:
		encounter = Encounter.new()
	
	currently_displayed_encounter = encounter
	if not unstable_cable.hasFailed:
		update_encounter_ui(encounter)
		
	
func update_encounter_ui(encounter :  Encounter):
	encounter_ui.update_encounter_ui(encounter)

func update_resolve_machine_ui(state : ResolveDissmiss.ResolveMachineState):
	resolve_dismiss_ui.update_resolve_machine_ui(state)

func unstable_cable_fail()->void:
	update_encounter_ui(Encounter.new())
	update_resolve_machine_ui(ResolveDissmiss.ResolveMachineState.NO_ENCOUNTER)
	if not unstable_cable.hasFailed:
		update_resolve_machine_ui(ResolveDissmiss.ResolveMachineState.NONE)

func unstable_cable_restored()->void:
	update_encounter_ui(currently_displayed_encounter)
	update_resolve_machine_ui(ResolveDissmiss.ResolveMachineState.NONE)
