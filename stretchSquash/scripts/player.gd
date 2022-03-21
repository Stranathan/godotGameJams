extends KinematicBody2D

#export (int) var jumpHeight = get_viewport().get_rect().size.y / 4.0

# Brain Dump
#-----------------------------------------------------------------
# So, is_on_floor() rets true is there was a collision with down normal on last frame
# from move_and_slide --> call is after move_and_slide

#-----------------------------------------------------------------
# All numbers are relative to the cell size of the tiles
# Player is 1 cell in height
# Player Jumps 2.5 his own height
# Player Jumps 3 his own width

#-----------------------------------------------------------------
var cellSize: float = 64.0;
var playerHeight: float = cellSize

#-----------------------------------------------------------------
var snap_length = 10 # is this in pixels?
var maxSlides: int = 4
var maxInclineForStopping: float = deg2rad(52)
#-----------------------------------------------------------------
onready var velocity: Vector2 = Vector2.ZERO
onready var jumpHeight: float = playerHeight * 5.0
onready var halfJumpDist: float = playerHeight * 4;
onready var halfJumpTime: float = 0.3
onready var gravity: float
onready var initialVelY: float
onready var initialVelX: float = halfJumpDist / halfJumpTime
#onready var halfJumpTime: float = 0.5 # marios jump time is like 0.3

#------------------ State ------------------
onready var isFalling: bool
onready var isJumping: bool

# child nodes
#-----------------------------------------------------------------
onready var smokeAnim: AnimatedSprite = $AnimatedSprite
onready var smokeAnimOffset: Vector2 = Vector2.ZERO
onready var smokeAnimStartPos: Vector2 = Vector2.ZERO

# SHADER
#-----------------------------------------------------------------
onready var squashStretch: Vector2 = Vector2.ZERO

func _ready():
	initialVelY = -(2.0 * jumpHeight) / halfJumpTime
	gravity = (2.0 * jumpHeight) / (halfJumpTime * halfJumpTime)
	print("x at peak of jump: " + String(halfJumpDist))
	print("y at peak of jump: " + String(jumpHeight))
	print("init VelX " + String(initialVelX))
	print("init VelY " + String(initialVelY))
	
	#-------------------------------------------------------
	smokeAnim.set_visible(false)
	smokeAnim.playing = false
	
func _process(delta):
	updateShaders(delta)
	
func _physics_process(delta):
	
	# query input
	updateInput(delta)
	
	var snap = Vector2.DOWN * 32 if !isJumping else Vector2.ZERO
	
	# add acceleration every physics frame
	velocity.y += gravity * delta
	# This is setting the velocity to zero
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, true, maxSlides, maxInclineForStopping)
	
	updateState()
	

func updateInput(delta):
	
	if Input.is_action_pressed("right"):
		velocity.x = initialVelX
	elif Input.is_action_pressed("left"):
		velocity.x = -initialVelX
	else:
		velocity.x = 0
	if Input.is_action_just_released("jump"):
		# world is inverted --> only check for when velocity is negative (going up)
		if velocity.y < 0:
			velocity.y = 0
	#-----------------------------------------
	# jump state should be taken from level init instead of checking null
	if Input.is_action_just_pressed("jump") && isJumping == false:
		squashStretch.y = 1.0
		isJumping = true
		velocity.y += initialVelY
		smokeAnim.set_visible(true)
		smokeAnim.playing = true
		
		# get offset start pos
		smokeAnimStartPos.x = position.x
		smokeAnimStartPos.y = position.y
	
		
func updateState():
	if(isJumping):
		# correct for animated sprite offset to where jump started
		smokeAnimOffset = smokeAnimStartPos - position
		smokeAnim.position = smokeAnimOffset
	
	# --------- LANDING
	if is_on_floor():
		if isJumping || isFalling:
			Input.start_joy_vibration(0, 0.3, 0.0, 0.1)
			squashStretch.x = 1
			
		isJumping = false
		isFalling = false
	else:
		isFalling = true
	
	# manually resetting animation frames
	if smokeAnim.frame == 8:
		smokeAnim.set_visible(false)
		smokeAnim.playing = false
		smokeAnim.frame = 0
		smokeAnim.position = Vector2.ZERO
	
func updateShaders(delta):
	if squashStretch.x > 0:
		squashStretch.x -= 4.0 * delta
	else:
		squashStretch.x = 0.0;
	if squashStretch.y > 0:
		squashStretch.y -= 2.0 * delta
	else:
		squashStretch.y = 0.0;
		
	$Sprite.material.set_shader_param("squashStretch", squashStretch)
