extends Node

enum GameState {MAIN_MENU, GAME, CREDITS}

const MAIN_MENU_PATH = "res://scenes/menus/main_menu.tscn"
const MAIN_GAME_PATH = "res://test/TestMainUI.tscn"


func change_game_scene(game_state : GameState) ->void:
	match game_state:
		GameState.MAIN_MENU:
			get_tree().change_scene_to_file(MAIN_MENU_PATH)
		GameState.GAME:
			get_tree().change_scene_to_file(MAIN_GAME_PATH)

	
