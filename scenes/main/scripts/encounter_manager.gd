class_name EncounterManager extends Node

var ENCOUNTER_POOL : Array = Utils.load_files_from_path("res://resources/encounter/")

var _available_encounters : Array[Encounter] = []
var _available_targets : Array[Encounter] = [
	preload("res://resources/encounter/enc25_grand_soir.tres"),
	preload("res://resources/encounter/enc20_horse.tres"),
	preload("res://resources/encounter/enc27_iskandar.tres"),
	preload("res://resources/encounter/enc18_misa.tres"),
	preload("res://resources/encounter/enc12_cain.tres"),
	preload("res://resources/encounter/enc13_bella.tres"),
	]
var _current_target : Encounter = null

var target_probability : int = 0
var passive_probability : int = 50
var aggressive_probability : int = 20

var amount_target_killed : int = 0
var amount_target : int = 0

signal new_target_update_order 

func _init() -> void:
	for encounter in ENCOUNTER_POOL:
		if not encounter.type == Encounter.Type.TARGET:
			_available_encounters.append(encounter)

	amount_target = _available_targets.size()
	_set_new_target()

func get_current_target()->Encounter:
	return _current_target

func get_new_encounter() -> Encounter:
	if _available_encounters.is_empty():
		return null
	
	var county_the_count : int = 0 #county is a good boi
	var selected_encounter : Encounter = null
	var keep_trying = true
	#dispositif de securite, au cas ou les proba ne veulent pas probater,
	#ou que la liste de rencontres dispo est mal foutue (ce qui serait plus plausible) 
	while county_the_count<1000 && keep_trying:
		county_the_count+=1
		selected_encounter = _available_encounters.pick_random()
		var probability_to_be_selected : int
		match selected_encounter.type:
			Encounter.Type.PASSIVE:
				probability_to_be_selected = passive_probability
			Encounter.Type.AGRESSIVE:
				probability_to_be_selected = aggressive_probability
			Encounter.Type.TARGET:
				probability_to_be_selected = target_probability
		
		#tirage d'un entier pour savoir si on garde cette rencontre
		if  randi_range(0,99)<probability_to_be_selected:
			keep_trying = false
		
	if selected_encounter.type == Encounter.Type.TARGET:
		target_probability = 0
		passive_probability = 100
		aggressive_probability = 100
	else:
		target_probability = clampi(target_probability+20,0,100)
		passive_probability = clampi(passive_probability-20,0,100)
		aggressive_probability = clampi(aggressive_probability-20,0,100)
	
	return selected_encounter 

func encounter_processed(encounter : Encounter, killed :bool)->void:
	_available_encounters.erase(encounter)
	
	if encounter.type == Encounter.Type.TARGET:
		_set_new_target()
		if killed:
			amount_target_killed+=1
	
func _set_new_target()->void:
	if _available_targets.is_empty():
		return
	_current_target = _available_targets.pop_front()
	_available_encounters.append(_current_target)
	new_target_update_order.emit()

func are_encounter_remaining()->bool:
	return !_available_encounters.is_empty()

func are_all_target_dead()-> bool:
	return amount_target_killed == amount_target

func are_any_target_dead()->bool:
	return amount_target_killed>0 
