extends Control

@onready var skip: Button = %Skip
@onready var add: Button = %Add
@onready var main_countdown: MainCountdown = %MainCountdown
@onready var countdown: Timer = %Countdown

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skip.pressed.connect(skip_test)
	add.pressed.connect(add_30_sec)
	
func _physics_process(delta: float) -> void:
	if not main_countdown.is_skipping:
		main_countdown.displayed_time = countdown.time_left
		
func add_30_sec()->void:
	countdown.start(countdown.time_left+30)
	countdown.paused = true
	print("adding 30 sec")
	await main_countdown.animate_time_skip(-1,30)
	print("Adding finished")
	countdown.paused = false
	
func skip_test()->void:
	countdown.start(90)
	countdown.paused = true
	print("Skipping")
	await main_countdown.animate_time_skip(120,90)
	print("Skipping Finished")
	countdown.paused = false
