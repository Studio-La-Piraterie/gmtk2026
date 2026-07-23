class_name MainUI extends Control

@onready var main_countdown_label: Label = %MainCountdownLabel
@onready var lucarne: TextureRect = %Lucarne
@onready var reponse: Label = %Reponse
@onready var description: Label = %Description
@onready var wave_form: Label = %WaveForm
@onready var type: ColorRect = %Type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_encounter(Encounter.new())
	
func update_main_countdown(time_left : float) -> void:
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	main_countdown_label.text = "%02d:%02d" % [minute,second]

func set_encounter(encounter : Encounter) -> void:

	if not is_node_ready() :
		return
	
	lucarne.texture = encounter.sprite
	reponse.text = "Reponse:" + encounter.response
	description.text = "Description:" + encounter.description
	wave_form.text = "Wave Form:" + str(encounter.wave_form)
	type.color = type2color(encounter.type)
	
func type2color (encounter_type : Encounter.Type) -> Color :
	match encounter_type:
		Encounter.Type.PASSIVE:
			return Color.GREEN
		Encounter.Type.AGRESSIVE:
			return Color.RED
		Encounter.Type.TARGET:
			return Color.DEEP_SKY_BLUE
	return Color.BLACK
