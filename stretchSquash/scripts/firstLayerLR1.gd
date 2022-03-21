extends KinematicBody2D

onready var tween = $Tween
onready var moveExtents: Array = [position.x - 200, position.x + 200]
onready var xMoveVals: Array = [position.x - 200, position.x, position.x + 200, position.x]
onready var xMoveIndex: int = 0

func _ready():
	add_to_group("leftRightFirstLayer")
	
func startTween():
	print(xMoveVals[xMoveIndex])
	tween.interpolate_property(self, "position", position, Vector2(xMoveVals[xMoveIndex], position.y),
	0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
#	moveExtents.invert()
	xMoveIndex += 1
	xMoveIndex %= 4
