extends KinematicBody2D

#----------------------------------------------
onready var maxHorizontalSpeed = 500
onready var maxVerticalSpeed = 500

#----------------------------------------------
onready var selected: bool = false
onready var target: Vector2 = global_position
onready var vel: Vector2 = Vector2.ZERO
onready var accl: Vector2 = Vector2.ZERO
onready var speed: float = 300
onready var arriveDistThreshold: float = 15.0

func _ready():
	$Sprite.material = load("res://materials/aClickyMat.tres").duplicate(true)
	
func _process(delta):
	if(selected):
		$Sprite.get_material().set_shader_param("hlSwitch", 1.0)
	else:
		$Sprite.get_material().set_shader_param("hlSwitch", 0.0)

func _physics_process(delta):
	if global_position.distance_to(target) > arriveDistThreshold:
		seek()
		print(target)
	else:
		arrive()
		
	eulerUpdate()
	
func seek():
	var desired = (target - global_position)
	desired = desired.normalized() * speed
	var steering = desired - vel
	addForce(steering)
	
func arrive():
	var t = global_position.distance_to(target) / arriveDistThreshold # t ∈ [0, 1]
	var s = t * speed
	var desired = (target - global_position)
	desired = desired.normalized() * s
	var steering = desired - vel
	addForce(steering)
	
func eulerUpdate():
	vel += accl
	vel.x = clamp(vel.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	vel.y = clamp(vel.y, -maxVerticalSpeed, maxVerticalSpeed)
	vel = move_and_slide(vel)
	accl = Vector2.ZERO
	
func addForce(f : Vector2):
	accl += f
