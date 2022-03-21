extends KinematicBody2D

onready var tween = $Tween
onready var moveExtents: Array = [position.x + 200, position.x - 200]

func _ready():
	add_to_group("leftRightFirstLayer")
	
func startTween():
	tween.interpolate_property(self, "position", position, Vector2(moveExtents[0], position.y),
	0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	moveExtents.invert()
