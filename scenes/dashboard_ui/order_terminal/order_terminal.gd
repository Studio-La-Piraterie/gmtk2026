extends Control

@onready var terminal: TextureRect = %Terminal
@onready var order_display: Label = %OrderDisplay
@onready var order_gif: GIFPlayer = %OrderGif
@onready var disable_btn: BaseButton = %Disable

@export var _displayed_target_order : Encounter = null
var disabled := false

func _ready() -> void:
	set_encounter_order(_displayed_target_order)
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

func _update_ui(encounter : Encounter)->void:
	if encounter == null:
		encounter = Encounter.new()
	order_display.text = encounter.target_order
	if encounter.show_oscillo:
		order_gif.gif = encounter.oscillo_gif
	else:
		order_gif.gif = null

func disable() -> void:
	disabled = true
	_update_ui(null)

func enable() -> void:
	disabled = false
	_update_ui(_displayed_target_order)
