extends Node

onready var c1: KinematicBody2D = $aClicky
onready var c2: KinematicBody2D = $aClicky2
onready var c3: KinematicBody2D = $aClicky3

onready var material: Material = $Sprite.get_material()
onready var scale: Vector2 = self.global_scale

# ---------------------------------------------------------
# I don't know why, but the relative child's position is always on [-32, 32]

# ---------------------------------------------------------
func _ready():
	pass
	
func _process(delta):
	material.set_shader_param("scale", scale)
	material.set_shader_param("c1", c1.position)
	material.set_shader_param("c2", c2.position)
	material.set_shader_param("c3", c3.position)
