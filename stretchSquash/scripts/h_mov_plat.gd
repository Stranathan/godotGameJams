extends Node

func _ready():
	$AudioStreamPlayer2D.connect("beat", $Node2D, "startTween")
