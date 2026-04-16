extends Node

var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var current_music: AudioStream = null

func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	sfx_player = AudioStreamPlayer.new()
	add_child(music_player)
	add_child(sfx_player)

func play_music(stream: AudioStream, fade: bool = true) -> void:
	if current_music == stream:
		return
	current_music = stream
	music_player.stream = stream
	music_player.volume_db = linear_to_db(GameState.music_volume)
	music_player.play()

func play_sfx(sfx_name: String) -> void:
	# Try to load from common paths
	var paths = [
		"res://resources/audio/sfx/" + sfx_name + ".ogg",
		"res://resources/audio/sfx/" + sfx_name + ".wav",
	]
	for path in paths:
		if ResourceLoader.exists(path):
			var stream = load(path)
			if stream:
				sfx_player.stream = stream
				sfx_player.volume_db = linear_to_db(GameState.sfx_volume)
				sfx_player.play()
			return

func set_music_volume(vol: float) -> void:
	GameState.music_volume = vol
	music_player.volume_db = linear_to_db(vol)

func set_sfx_volume(vol: float) -> void:
	GameState.sfx_volume = vol

func stop_music() -> void:
	music_player.stop()
	current_music = null
