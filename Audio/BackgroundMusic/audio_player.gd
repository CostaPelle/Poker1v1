extends AudioStreamPlayer2D

var MusicNumber = 0

var Music = ["res://Audio/BackgroundMusic/smooth-jazz-saxophone-solo-with-a-lofi-vibe-253950.mp3", "res://Audio/BackgroundMusic/latte-glow-254085.mp3","res://Audio/BackgroundMusic/golden-hour-chill-254090.mp3", "res://Audio/BackgroundMusic/important-to-you-pecan-pie-main-version-18025-02-06.mp3", "res://Audio/BackgroundMusic/podcast-smooth-jazz-instrumental-music-225674.mp3"]

const level_music = preload("res://Audio/BackgroundMusic/smooth-jazz-saxophone-solo-with-a-lofi-vibe-253950.mp3")

func _ready() -> void:
	pass


func _play_music(music: AudioStream, volume = -15.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()

func play_music_level():
	_play_music(load(Music[MusicNumber]))


func _on_finished() -> void:
	MusicNumber += 1
	if MusicNumber > 4:
		MusicNumber = 0
	play_music_level()
