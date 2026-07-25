class_name MainCountdown extends Label

#Ce label affiche un temps en format mm:ss. 
#Mettre a jour la variable displayed time controle le temps affiche
#La fonction animate_time_skip fais passer la valeur du timer une autre
#a la vitesse time_animation_speed. Il est safe de la relancer alors qu'elle
#est deja en cours d'execution. ATTENTION a bien synchroniser le chrono source 
#ATTENTION : il n'est pas safe de mettre a jour manuellement displayed time 
#alors qu'un time skip est en cours. Utiliser la variable is_skipping pour controler

@export var blink_time : float = 0.1
@export var time_animation_speed = 30#/s
var displayed_time : float = 60:
	set = set_displayed_time

var tween : Tween
var is_skipping : bool = false

func _ready() -> void:
	set_displayed_time(displayed_time)

func set_displayed_time(time_left : float) -> void:
	displayed_time = time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	text = "%02d:%02d" % [minute,second]

func animate_time_skip(from_time :float, to_time : float) -> void:
	if from_time == -1:
		from_time = displayed_time
		to_time = from_time+to_time

	if tween != null:
		tween.kill()
	
	is_skipping = true
	displayed_time = from_time
	visible = true
	tween = create_tween()
	tween.tween_callback(hide).set_delay(blink_time)
	tween.tween_callback(show).set_delay(blink_time)
	tween.tween_callback(hide).set_delay(blink_time)
	tween.tween_callback(show).set_delay(blink_time)
	
	var tween_duration : float = abs(from_time-to_time)/time_animation_speed

	tween.tween_property(self,"displayed_time",to_time,tween_duration)
	
	await tween.finished
	is_skipping = false
	
	
