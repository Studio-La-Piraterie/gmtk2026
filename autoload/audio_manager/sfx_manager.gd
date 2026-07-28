extends Node

func play_sfx(player: AudioStreamPlayer, tween: Tween):
	var prev_db = player.volume_db
	tween = AudioManager.create_player_tween(tween)
	player.play()
	tween.tween_property(player, "volume_db", 0.0, 0.3)
	await tween.finished
	#await player.finished
	player.volume_db = prev_db
