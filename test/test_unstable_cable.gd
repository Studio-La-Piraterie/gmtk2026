extends UnstableCable

@onready var is_broken: ColorRect = %IsBroken

func _ready() -> void:
	super()
	is_broken.color = Color.GREEN
	failed.connect(
		func()->void:
			is_broken.color = Color.GREEN
			)
	restored.connect(
		func()->void:
			is_broken.color = Color.RED
			)
			
