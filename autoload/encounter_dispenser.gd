class_name EncounterManager extends Node

var available_encounters : Array[Encounter] = [
	preload("res://resources/encounter/test_1.tres"),
	preload("res://resources/encounter/test_2.tres"),
	preload("res://resources/encounter/test_3.tres"),
	preload("res://resources/encounter/test_3.tres")
]

var target_probability : int = 0
var passive_probability : int = 50
var aggressive_probability : int = 20

var amount_target_killed : int = 0
var amount_target : int = 0

var encounter_audio_player := AudioStreamPlayer.new()

func _init() -> void:
	add_child(encounter_audio_player)
	encounter_audio_player.bus = "Encounter"
	amount_target  = 0
	for encounter in available_encounters:
		if encounter.type == Encounter.Type.TARGET:
			amount_target+=1

	
func get_new_encounter() -> Encounter:
	if available_encounters.is_empty():
		return null
	
	var county_the_count : int = 0 #county is a good boi
	var selected_encounter : Encounter = null
	var keep_trying = true
	#dispositif de securite, au cas ou les proba ne veulent pas probater,
	#ou que la liste de rencontres dispo est mal foutue (ce qui serait plus plausible) 
	while county_the_count<1000 && keep_trying:
		county_the_count+=1
		selected_encounter = available_encounters.pick_random()
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

func are_encounter_remaining()->bool:
	return !available_encounters.is_empty()

func are_all_target_dead()-> bool:
	return amount_target_killed == amount_target

func are_any_target_dead()->bool:
	return amount_target_killed>0 

func play_audio(audio_stream : AudioStream) ->void:
	encounter_audio_player.stream = audio_stream
	encounter_audio_player.play()

func stop_audio()->void:
	encounter_audio_player.stop()
