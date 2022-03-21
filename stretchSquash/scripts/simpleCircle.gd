extends MeshInstance



export var radius = 2.0

onready var timeSoFar = 0

func _ready():
	pass
	
func _physics_process(delta):
	
	timeSoFar += delta
	
#	make a simple circle path:
	translation.x = radius * cos(timeSoFar)
	translation.y = radius * sin(timeSoFar)

	pass

