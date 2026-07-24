extends UnstableCable

@onready var is_broken: ColorRect = %IsBroken
@onready var label: Label = %Label

func _ready() -> void:
	super()
	is_broken.color = Color.GREEN
	failed.connect(
		func()->void:
			is_broken.color = Color.RED
			label.text = "Unstable Cable : Broken"
			)
	restored.connect(
		func()->void:
			is_broken.color = Color.GREEN
			label.text = "Unstable Cable : Fixed"
			)
			
