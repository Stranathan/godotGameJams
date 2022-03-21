extends AudioStreamPlayer

signal beat

# defined per song
export var bpm := 100
export var measures := 4

# Tracking the beat and song position
var song_position = 0.0
var song_position_in_beats = 1
var sec_per_beat: float = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var measure = 1

# Determining how close to the beat an event is
#var closest = 0
#var time_off_beat = 0.0

onready var prevBeat = -1

func _ready():
	sec_per_beat = 60.0 / bpm # 60 s / (beats / 1m)
	playing = true

func _physics_process(_delta):
	# playing is a bool in AudioStreamPlayer
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		# song_position will be in seconds
		# song_position / sec_per_beat --> real number of how many beats in we are
		song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
		
		
		if prevBeat != song_position_in_beats:
			prevBeat = song_position_in_beats
			print(song_position_in_beats)
			#emit_signal("beat")
			sendOutBeat()
			
func sendOutBeat():
#	emit_signal("beat", 1.0)
	get_tree().call_group("leftRightFirstLayer", "startTween")

