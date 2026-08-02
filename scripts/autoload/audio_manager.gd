extends Node
## Simple audio manager (Autoload singleton)

var _music_player: AudioStreamPlayer
var _sfx_player: AudioStreamPlayer

func _ready() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Music"
	add_child(_music_player)

	_sfx_player = AudioStreamPlayer.new()
	_sfx_player.bus = "SFX"
	add_child(_sfx_player)

func play_music(stream: AudioStream) -> void:
	if not GameManager.settings["music_enabled"]: return
	if _music_player.playing and _music_player.stream == stream: return
	_music_player.stream = stream
	_music_player.play()

func stop_music() -> void:
	_music_player.stop()

func play_sfx(stream: AudioStream) -> void:
	if not GameManager.settings["sound_enabled"]: return
	_sfx_player.stream = stream
	_sfx_player.play()

func set_music_enabled(enabled: bool) -> void:
	GameManager.settings["music_enabled"] = enabled
	if not enabled: stop_music()

func set_sound_enabled(enabled: bool) -> void:
	GameManager.settings["sound_enabled"] = enabled
