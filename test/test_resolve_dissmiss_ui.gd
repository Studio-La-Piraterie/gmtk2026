extends Control

@export var encounter_list : Array[Encounter]

@onready var resolve_dismiss_ui: ResolveDissmiss = %ResolveDismissUI
@onready var encounter_type_lbl: Label = %EncounterTypeLbl
@onready var encounter_status: Label = %EncounterStatus
@onready var get_new_encounter: Button = %GetNewEncounter
@onready var disabled_state: Label = %DisabledState
@onready var disable_btn: Button = %DisableBtn

var current_encounter: Encounter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	disable_btn.toggled.connect(func(toggled_on : bool) :
			if toggled_on:
				resolve_dismiss_ui.disable()
			else:
				resolve_dismiss_ui.enable()
			)
	get_new_encounter.pressed.connect(go_to_next_encounter)
	
	resolve_dismiss_ui.kill_encounter.connect(kill_encounter)
	resolve_dismiss_ui.dismiss_encounter.connect(dissmiss_encounter)

func go_to_next_encounter() -> void:
	resolve_dismiss_ui.set_state(ResolveDissmiss.ResolveMachineState.ENCOUNTER_PRESENT)
	current_encounter = encounter_list.pop_front()
	encounter_list.append(current_encounter) #on rajoute l'encounter qu'on vient d'enlever  la fin de la liste pour faire rouler

	encounter_type_lbl.text = "Encounter type:" + encounter_type2str(current_encounter.type)


func kill_encounter() ->void:
	resolve_dismiss_ui.set_state(ResolveDissmiss.ResolveMachineState.NO_ENCOUNTER)
	encounter_type_lbl.text = "Encounter type:"
	encounter_status.text = "Last encounter status: killed"
	
func dissmiss_encounter() ->void:
	resolve_dismiss_ui.set_state(ResolveDissmiss.ResolveMachineState.NO_ENCOUNTER)
	encounter_type_lbl.text = "Encounter type:"
	encounter_status.text = "Last encounter status: dissmissed"

func encounter_type2str(encounter_type : Encounter.Type)->String:
	var return_str : String = ""
	
	match encounter_type:
		Encounter.Type.PASSIVE:
			return_str = "Passive"
		Encounter.Type.AGRESSIVE:
			return_str = "Aggressive"
		Encounter.Type.TARGET:
			return_str = "Target"
			
	return return_str
