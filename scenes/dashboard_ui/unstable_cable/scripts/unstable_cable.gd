class_name UnstableCable extends Control

const PLUG_AUDIO = preload("res://assets/audio/sfx/plug.wav")
const UNPLUG_AUDIO = preload("res://assets/audio/sfx/unplug.wav")

@export var min_failure_countdown : float = 40
@export var max_failure_countdown : float = 90

@export var restore_btn : BaseButton
@export var plug_unplug_audio : AudioStreamPlayer 
@export var bzit_animation: AnimationPlayer 

var failure_timer := Timer.new()
var hasFailed := false

signal failed
signal restored

func _ready() -> void:
	restore_btn.toggle_mode = true
	restore_btn.button_pressed = true
	restore_btn.disabled = true

	add_child(failure_timer)
	restart_failure_timer()

	failure_timer.timeout.connect(fail)
	restore_btn.pressed.connect(restore)

func restart_failure_timer()->void:
	failure_timer.start(randf_range(min_failure_countdown,max_failure_countdown))


func fail()->void:
	print("Fail")
	bzit_animation.play("bzit")

	failure_timer.stop()
	restore_btn.disabled = false
	restore_btn.button_pressed = false
	hasFailed = true
	plug_unplug_audio.stream = UNPLUG_AUDIO
	plug_unplug_audio.play()
	failed.emit()
	
func restore()->void:
	print("Restore")
	failure_timer.start()
	restore_btn.disabled = true
	restore_btn.button_pressed = true
	hasFailed = false
	plug_unplug_audio.stream = PLUG_AUDIO
	plug_unplug_audio.play()
	restored.emit()
