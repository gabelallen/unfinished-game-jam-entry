extends Node2D

@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#random sprite from spritesheet
	sprite.region_rect = Rect2(((randi()%3)*16),0,16,16)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
