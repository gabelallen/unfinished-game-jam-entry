extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "FPS: " + str(Engine.get_frames_per_second())
	text += "\n" + str(float(int(delta*10000)%1000)/10) + "ms" #maybe im an idiot
	text += "\n" + str(get_tree().get_nodes_in_group("moving_characters").size())
	pass
