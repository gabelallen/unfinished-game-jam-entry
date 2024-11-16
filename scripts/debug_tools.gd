extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_1 and event.pressed: #spawn little guy at cursor
			for i in 5:
				var littleguyscene = load("res://scenes/little_guy.tscn").instantiate()
				littleguyscene.position = get_global_mouse_position()
				
				#make them move along
				littleguyscene.target_position = Global.latest_destination+Vector2(randi()%20, randi()%20)
				littleguyscene.is_moving = true
				littleguyscene.is_selected = true
				
				get_parent().add_child(littleguyscene)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
