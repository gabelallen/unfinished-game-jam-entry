extends CharacterBody2D

@onready var rect = $ColorRect
@onready var animation = $AnimatedSprite2D

signal hit_rock_signal

#movement
var target_reach_distance = 15.0
var speed = 200.0
var wobble_amount = 3.0
var wobble_speed_max = 30.0
var target_position: Vector2
var is_moving = false
var is_following_cursor = false
var wobble_time = 0.0
var prev_position = Vector2.ZERO
var realspeed = 0
var min_command_timer = 1 #how long a command MUST be followed
var cur_command_timer = 0 #how long the most recent command was followed

var birth_color
var is_highlighted = false
var is_selected = false

var has_hit = false

var hp = 3

var colors = [ 
	#https://coolors.co/011627-fdfffc-2ec4b6-e71d36-ff9f1c
	#https://coolors.co/palette/ff9f1c-ffaf43-ffbf69-ffdfb4-ffffff-e5f9f8-cbf3f0-7ddcd3-2ec4b6
	#Color("#011627"), #rich black
	#Color("fdfffc"), #baby powder
	Color("2ec4b6"), #light sea green
	Color("e5f9f8"),
	Color("cbf3f0"),
	Color("e5f9f8"),
	Color("7DDCD3"),	
	#Color("e71d36"), #red (pantone)
	#Color("#FF9F1C"), #orange peel
]

#collision
var squish_radius = 30.0#distance when the pushing starts
var avoidance_strength = 1000.0 #strength of the pushback

func _ready() -> void:
	#get randomc color
	Global.friends.append(self)
	Global.reach_scalar = sqrt(Global.friends.size())
	add_to_group("moving_characters")
	
	birth_color = colors[randi() % colors.size()]
	animation.modulate = birth_color
	rect.color = birth_color
	
	#+-10% for variation
	animation.speed_scale *= 1 + 0.01 * (randi()%20) * Global.random_sign()
	speed *= 1 + 0.01 * (randi()%20) * Global.random_sign()
	wobble_amount *= 1 + 0.01 * (randi()%20) * Global.random_sign()
	wobble_speed_max *= 1 + 0.01 * (randi()%20) * Global.random_sign()	
	
	rect.visible =false
	animation.play("idle")	
	prev_position = global_position

func _input(event):
	if event is InputEventMouseButton:
		if is_selected:
			if event.button_index == MOUSE_BUTTON_RIGHT: 
				if event.pressed: #held downw
					is_following_cursor = true
					target_position = get_global_mouse_position()
					is_moving = true
					
					if(target_position.distance_to(Global.rockpos)<36):
						target_reach_distance = 30
					else: target_reach_distance = 15
				else: #clicked
					is_following_cursor = false
			else: is_following_cursor = false

func _process(delta):
	if is_selected || is_highlighted: 
		animation.modulate = Color(birth_color)
		#rect.visible = true
	else: 
		animation.modulate = Color(birth_color.r - 0.2, birth_color.g - 0.2, birth_color.b - 0.2, birth_color.a)
	
	if animation.animation == "kick":
		if animation.frame > 0 and !has_hit:
			emit_signal("hit_rock_signal")
			has_hit = true
		elif animation.frame == 0 and has_hit:
			has_hit = false
	
	Global.latest_destination = target_position
	realspeed = global_position.distance_to(prev_position) / delta
	prev_position = global_position
	
	if is_following_cursor:
		target_position = get_global_mouse_position()
		cur_command_timer = 0
	else:
		cur_command_timer+=delta #this is necessary bc we want there to be NO timer when we are hold down RMB
	
	if is_moving:
		animation.play("walk")
		#rect.color = Color('green')
		var direction = (target_position - global_position).normalized()
		velocity = direction * speed
		
		if direction.x <= 0:
			animation.flip_h = false
		else: 
			animation.flip_h = true

		#collision
		for other in Global.friends:
			if other != self:
				var distance = global_position.distance_to(other.global_position)
				if distance < squish_radius:
					var push_away = (global_position - other.global_position).normalized() * avoidance_strength / distance
					velocity += push_away
					if cur_command_timer > min_command_timer && realspeed < 37 && global_position.distance_to(target_position) < target_reach_distance*Global.reach_scalar:
						cur_command_timer = 0
						is_moving = false
						velocity = Vector2.ZERO
						rotation = 0.0
						is_following_cursor = false
						animation.play("idle")
						

		move_and_slide()
		
		#movement wobble
		var wobble_speed = (realspeed/speed)*wobble_speed_max #wobble speed scales with real speed
		wobble_time += delta * wobble_speed
		animation.rotation = deg_to_rad(sin(wobble_time) * wobble_amount)

		if global_position.distance_to(target_position) < target_reach_distance and not is_following_cursor:
			cur_command_timer = 0
			is_moving = false
			velocity = Vector2.ZERO
			rotation = 0.0
			is_following_cursor = false
			animation.play("idle")			
	else:
		animation.rotation = 0		
		if(cur_command_timer > min_command_timer and position.distance_to(Global.rockpos) < 55): hit_rock()
		else:
			animation.play("idle")



func hit_rock():
	var direction = (Global.rockpos - global_position).normalized()
	if direction.x <= 0:
		animation.flip_h = false
	else: 
		animation.flip_h = true
	animation.play("kick")

func die():
	queue_free()
