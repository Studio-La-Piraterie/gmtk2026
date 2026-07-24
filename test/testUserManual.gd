class_name  UserManual extends Node

@export var pages_arr : Array[ManualPage]

@onready var left_page = $PagesContainer/LeftPage
@onready var right_page = $PagesContainer/RighPage

# -1 signifie aucune page à afficher | 
# La première page commence à l'index 0 (couverture)
# La dernière page pages_arr.size() est la 4ème de couverture
var current_left_page : int = -1
var current_right_page : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## On tourne la page, sauf si la dernière page est déjà atteinte
func next_page() -> void:
	# Si la page de droite ne contient aucune page, on annule
	if current_right_page == -1:
		return
	# Si on est à la dernière page à droite, on enlève la page de droite
	if current_right_page + 1 == pages_arr.size():
		current_right_page = -1
	else:
		current_right_page += 1
	current_left_page += 1

func previous_page() -> void:
	# Si la page de gauche ne contient aucune page, on annule
	if (current_left_page == -1):
		return
	# Si on est à la première page à gauche, on enlève la page de gauche
	if current_left_page == 0:
		current_left_page = -1
	else:
		current_left_page -= 1
	current_right_page -= 1
	
func set_right_page() -> void:
	if current_right_page == -1:
		right_page.texture = null
	elif current_right_page + 1 <= pages_arr.size():
		right_page.texture = pages_arr[current_right_page].sprite

func set_left_page() -> void:
	if current_left_page == -1:
		left_page.texture = null
	elif current_left_page + 1 <= pages_arr.size():
		left_page.texture = pages_arr[current_left_page].sprite
