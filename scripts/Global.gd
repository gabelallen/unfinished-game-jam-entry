extends Node

var friends = []#array of little guys on map
var latest_destination = Vector2.ZERO
var is_following_cursor = false
var rockpos = Vector2.ZERO #position of the rock
var reach_scalar = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#for slightly randomizing attributes
func random_sign():
	if randi() % 2 == 0:
		return -1
	return 1
