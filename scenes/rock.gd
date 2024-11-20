extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var hurt_timer = $HurtTimer

var recently_hurt = false

var squish_radius = 38
var avoidance_strength = 2300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("default")
	add_to_group("objects")
	Global.rockpos = position
	z_index = -1
pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var friends = get_tree().get_nodes_in_group("moving_characters")
	for other in friends:
		var distance = global_position.distance_to(other.global_position)
		if distance < squish_radius:
			var push_away = (global_position - other.global_position).normalized() * avoidance_strength / distance
			other.velocity = -push_away - Vector2((randi()%150),(randi()%150))
			other.move_and_slide()
	pass


func _on_little_guy_hit_rock_signal() -> void:
	if(!recently_hurt):
		#spawn debris
		var debris = load("res://scenes/debris.tscn").instantiate()	
		var angle = randf() * PI * 2
		var distance = randi_range(32, 64)
		var offset = Vector2(cos(angle), sin(angle)) * distance
		debris.position = position + offset	
		get_parent().add_child(debris)
		
		#hurt the rock
		sprite.modulate = Color(0.7, 0.7, 0.7, 1.0)
		sprite.play("hurt")
		recently_hurt = true
		hurt_timer.start()
		pass # Replace with function body.


func _on_hurt_timer_timeout() -> void:
	recently_hurt = false
	sprite.modulate = Color(1, 1, 1, 1.0)
	sprite.play("default")
	pass # Replace with function body.
