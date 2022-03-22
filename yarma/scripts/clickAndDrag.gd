extends Node2D

onready var dragging: bool = false
onready var draggingStartPos: Vector2
onready var draggingPos: Vector2

onready var spaceState
onready var selectionRect = RectangleShape2D.new()  # Collision shape for drag box.
onready var selectedClickies: Array = []

func _unhandled_input(event):
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
				dragging = true
				draggingStartPos = event.position
				
		elif dragging:
			dragging = false
			var draggingEndPos = event.position
#			
			selectionRect.extents = (draggingEndPos - draggingStartPos) / 2.0
			var query = Physics2DShapeQueryParameters.new()
			query.set_shape(selectionRect)
			# translation should be to the middle of the rect
			query.transform = Transform2D(0, draggingStartPos + selectionRect.extents)
													 
			selectedClickies = spaceState.intersect_shape(query)
			update() # update the canvas to clear draw rect
			
			print(selectedClickies)
			for clicky in selectedClickies:
				clicky.collider.selected = true
				
	if event is InputEventMouseMotion and dragging:
		draggingPos = event.position
		update() # update() --> _draw()
	
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		if event.is_pressed():
			print(event.position)
			if selectedClickies.size() != 0:
				for clicky in selectedClickies:
					clicky.collider.target = event.position
					clicky.collider.selected = false
				selectedClickies = []

func _physics_process(delta):
	spaceState = get_world_2d().direct_space_state

func _draw():
	if dragging:
		draw_rect(
				Rect2(draggingStartPos, draggingPos - draggingStartPos),
				Color( 0.94, 0.97, 1),
				false,
				1.0,
				false)
			

