class_name  UserManual extends Node

@export var pages_arr : Array[ManualPage]

@onready var left_page = $PagesContainer/LeftPage
@onready var left_page_text = $PagesContainer/LeftPage/LeftPageText
@onready var left_page_button = $PagesContainer/LeftPage/LeftPageButton

@onready var right_page = $PagesContainer/RightPage
@onready var right_page_text = $PagesContainer/RightPage/RightPageText
@onready var right_page_button = $PagesContainer/RightPage/RightPageButton

# -1 signifie aucune page à afficher | 
# La première page commence à l'index 0 (couverture)
# La dernière page pages_arr.size() est la 4ème de couverture
var current_left_page : int = -1
var current_right_page : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_page_button.pressed.connect(previous_page)
	right_page_button.pressed.connect(next_page)
	set_left_page()
	set_right_page()
	if pages_arr.size() % 2 != 0:
		push_error("The number of pages of the user manual is odd, risks of bug")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func next_page() -> void:
	# Si la page de droite ne contient aucune page, on annule
	if current_right_page == -1:
		return
	# Si on est à la dernière page à droite, on enlève la page de droite
	if current_right_page + 2 >= pages_arr.size():
		current_right_page = -1
	else:
		current_right_page += 2
	current_left_page += 2
	set_left_page()
	set_right_page()

func previous_page() -> void:
	# Si la page de gauche ne contient aucune page, on annule
	if current_left_page == -1:
		return
	if current_right_page == -1:
		current_right_page = pages_arr.size() - 2
	else:
		current_right_page -= 2
	current_left_page -= 2
	set_left_page()
	set_right_page()
	
func set_right_page() -> void:
	right_page_text.clear()
	if current_right_page == -1:
		right_page.texture = null
	elif current_right_page + 1 <= pages_arr.size():
		right_page.texture = pages_arr[current_right_page].sprite
		right_page_text.add_text(pages_arr[current_right_page].text) 

func set_left_page() -> void:
	left_page_text.clear()
	if current_left_page == -1:
		left_page.texture = null
	elif current_left_page + 1 <= pages_arr.size():
		left_page.texture = pages_arr[current_left_page].sprite
		left_page_text.add_text(pages_arr[current_left_page].text)
