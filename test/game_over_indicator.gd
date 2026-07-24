extends Label

@onready var main_game_parent: MainGame = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if main_game_parent == null:
		return
	
	main_game_parent.game_over.connect(func(game_over_state : MainGame.GameOverType)->void:
		match game_over_state:
			MainGame.GameOverType.TIME_UP:
				text = "Game over state : Time Up on main countdown!"
			MainGame.GameOverType.PACIFIC_VICTORY:
				text = "Game over state : Pacific victory"
			MainGame.GameOverType.NEUTRAL_VICTORY:
				text = "Game over state : Neutral victory"
			MainGame.GameOverType.AGGRESSIVE_VICTORY:
				text = "Game over state : Aggressive victory"
		)
		
