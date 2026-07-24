class_name UnstableCable extends Control

@export var min_failure_countdown : float = 40
@export var max_failure_countdown : float = 90

@export var restore_btn := Button.new()

var failure_timer := Timer.new()
var hasFailed := false

signal failed
signal restored

func _ready() -> void:
	add_child(failure_timer)
	restart_failure_timer()

	restore_btn.disabled = true
	failure_timer.timeout.connect(fail)
	restore_btn.pressed.connect(restore)

func restart_failure_timer()->void:
	failure_timer.start(randf_range(min_failure_countdown,max_failure_countdown))

func fail()->void:
	failure_timer.stop()
	restore_btn.disabled = false
	hasFailed = true
	failed.emit()
	
func restore()->void:
	failure_timer.start()
	restore_btn.disabled = true
	hasFailed = false
	restored.emit()
