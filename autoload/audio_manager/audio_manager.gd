extends Node

@onready var encounter_audio_player = $EncounterAudioPlayer


func play_encounter_audio(stream: AudioStreamOggVorbis):
	if !encounter_audio_player.playing:
		var tween_encounter  = Utils.kill_and_create_tween()
		encounter_audio_player.stream = stream
		encounter_audio_player.play()
		tween_encounter.tween_property(encounter_audio_player, "volume_db", 20.0, 0.5)
		await tween_encounter.finished 

func stop_encounter_audio():
	if encounter_audio_player.playing:
		var tween_encounter  = Utils.kill_and_create_tween()
		tween_encounter.tween_property(encounter_audio_player, "volume_db", -60.0, 0.5)
		await tween_encounter.finished 
		encounter_audio_player.stop()
