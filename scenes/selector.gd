extends Node2D

var start_point: Vector2 = Vector2.ZERO
var end_point: Vector2 = Vector2.ZERO
var drawing_square: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 1000
	pass # Replace with function body.
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				#pressed down, start drawing
				start_point = get_global_mouse_position()
				end_point = start_point
				drawing_square = true
				queue_redraw()
			else:
				#release, stop drawing
				end_point = get_global_mouse_position()
				drawing_square = false
				select_highlighted_guys()
				queue_redraw()
	elif event is InputEventMouseMotion and drawing_square: #as the mouse moves
		end_point = get_global_mouse_position()
		queue_redraw()

func draw():	
	if drawing_square:
		var rect_position = Vector2(
			min(start_point.x, end_point.x), 
			min(start_point.y, end_point.y)
		)
		var rect_size = Vector2(
			abs(end_point.x - start_point.x), 
			abs(end_point.y - start_point.y)
		)
		var selection_rect = Rect2(rect_position, rect_size) #rect for drawing on screen
		var expanded_rect = selection_rect.grow(15) #actual seclection rect size is bigger
		
		draw_rect(selection_rect, Color(1, 0, 0, 0.3))
		draw_rect(expanded_rect, Color(0, 1, 0, 0.2))

		#highlight little guys in selection
		var little_guys = get_tree().get_nodes_in_group("moving_characters")
		for guy in little_guys:
			guy.is_selected = false
			if expanded_rect.has_point(guy.position):
				guy.is_highlighted = true
			else:
				guy.is_highlighted = false

func select_highlighted_guys():
	var little_guys = get_tree().get_nodes_in_group("moving_characters")
	for guy in little_guys:
		if guy.is_highlighted:
			guy.is_highlighted = false
			guy.is_selected = true
