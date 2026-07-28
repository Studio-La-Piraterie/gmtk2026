extends Node

@onready var menu_bgm: AudioStreamPlayer = $MenuBGM
@onready var encounter_audio_player: AudioStreamPlayer = $EncounterAudioPlayer
@onready var encounter_bgm: AudioStreamPlayer = $EncounterBGM

var tween_menu_bgm: Tween
var tween_encounter: Tween
var tween_encounter_bgm: Tween

var bgm_volume_reduced = false

func play_menu_bgm():
	if !menu_bgm.playing:
		tween_menu_bgm = create_player_tween(tween_menu_bgm)
		menu_bgm.play()
		tween_menu_bgm.tween_property(menu_bgm, "volume_db", 0.0, 1.5)
		await tween_menu_bgm.finished 
		
func reduce_bgm_volume():
	if !bgm_volume_reduced:
		var tween_bgm = Utils.kill_and_create_tween()
		tween_bgm.tween_property(AudioManager.menu_bgm, "volume_db", AudioManager.menu_bgm.volume_db - 10.0, 1.5).finished
		bgm_volume_reduced = true
	
func stop_menu_bgm():
	if menu_bgm.playing:
		tween_menu_bgm = create_player_tween(tween_menu_bgm)
		tween_menu_bgm.tween_property(tween_menu_bgm, "volume_db", -60.0, 0.5)
		await tween_menu_bgm.finished 
		menu_bgm.stop()

func play_encounter_audio(stream: AudioStreamOggVorbis):
	if !encounter_audio_player.playing:
		tween_encounter = create_player_tween(tween_encounter)
		encounter_audio_player.stream = stream
		encounter_audio_player.play()
		tween_encounter.tween_property(encounter_audio_player, "volume_db", 0.0, 1.0)
		await tween_encounter.finished 

func stop_encounter_audio():
	if encounter_audio_player.playing:
		tween_encounter = create_player_tween(tween_encounter)
		tween_encounter.tween_property(encounter_audio_player, "volume_db", -60.0, 0.5)
		await tween_encounter.finished 
		encounter_audio_player.stop()
		
func play_encounter_noise():
	if !encounter_bgm.playing:
		tween_encounter_bgm = create_player_tween(tween_encounter_bgm)
		encounter_bgm.play()
		await tween_encounter_bgm.tween_property(encounter_bgm, "volume_db", -10.0, 1.0).finished
		await get_tree().create_timer(encounter_bgm.stream.get_length() - 0.5, false).timeout
		stop_encounter_noise()

		
func stop_encounter_noise():
	if encounter_bgm.playing:
		tween_encounter_bgm = create_player_tween(tween_encounter_bgm)
		tween_encounter_bgm.tween_property(encounter_bgm, "volume_db", -60.0, 0.5)
		encounter_bgm.stop()

func create_player_tween(tween: Tween) -> Tween:
	tween = Utils.kill_and_create_tween(tween)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	return tween
