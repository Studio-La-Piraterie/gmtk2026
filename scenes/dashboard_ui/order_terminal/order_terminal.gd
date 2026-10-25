extends Control
class_name OrderTerminal

@onready var terminal: TextureRect = %Terminal
@onready var order_display: Label = %OrderDisplay
@onready var order_gif: GIFPlayer = %OrderGif
@onready var disable_btn: BaseButton = %Disable

@export var character_update_time : float = 0.09
@export var character_displayed : int = 3

@export var _displayed_target_order : Encounter = null
@export var sfx_order: AudioStreamPlayer 

var _typing_id: int = 0

var disabled := false

func _ready() -> void:
	set_encounter_order(_displayed_target_order)
	order_gif.gif = null
	disable_btn.toggled.connect(
		func(is_toggled : bool)->void:
			if is_toggled:
				disable()
			else:
				enable()
	)

func set_encounter_order(encounter : Encounter)->void:
	if encounter == null:
		encounter = Encounter.new()
	
	_displayed_target_order = encounter
	_update_ui(_displayed_target_order)
	sfx_order.play()

func _update_ui(encounter : Encounter)->void:
	if encounter == null:
		encounter = Encounter.new()
		
	order_display.text = ""
	
	for str in encounter.target_order:
		order_display.text += tr(str) + "\n"+"\n"
	update_terminal_text(order_display.text, 0.4)


	if encounter.show_oscillo:
		order_gif.gif = encounter.oscillo_gif
	else:
		order_gif.gif = null

func update_terminal_text(discussion : String, update_time: float) -> void:
	clear_terminal_text()
	order_display.text = tr(discussion)
	var array_words_order = order_display.text.split(" ")
	for display_array in array_words_order:
		order_display.visible_characters += display_array.length()
		if not display_array.ends_with("\n"):
			order_display.visible_characters += 1
		await get_tree().create_timer(update_time).timeout
	
## Clear the terminal
func clear_terminal_text() -> void:
	order_display.visible_characters = 0
	order_display.text.erase(0, order_display.text.length())

func disable() -> void:
	disabled = true
	_update_ui(null)

func enable() -> void:
	disabled = false
	_update_ui(_displayed_target_order)
