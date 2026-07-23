extends Node

var AVAILABLE_ENCOUNTERS : Array[Encounter] = [
	preload("res://resources/encounter/test_1.tres"),
	preload("res://resources/encounter/test_2.tres"),
	preload("res://resources/encounter/test_3.tres")
]

var target_probability : int = 0
var passive_probability : int = 50
var aggressive_probability : int = 20

func get_new_encounter() -> Encounter:
	var county_the_count : int = 0 #county is a good boi
	var selected_encounter : Encounter = null
	var keep_trying = true
	#dispositif de securite, au cas ou les proba ne veulent pas probater,
	#ou que la liste de rencontres dispo est mal foutue (ce qui serait plus plausible) 
	while county_the_count<1000 && keep_trying:
		county_the_count+=1
		selected_encounter = AVAILABLE_ENCOUNTERS.pick_random()
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
	
	  
