extends Node2D

var little_guys = []

func _physics_process(delta: float) -> void:
	little_guys = Global.friends
	if little_guys:
		update_z_index()

#make sure the nearest character shows on top
func update_z_index():
	#sort by y position
	little_guys.sort_custom(func(a,b):return a.position.y<b.position.y)

	#assign z index
	for i in range(len(little_guys)):
		little_guys[i].animation.z_index = i
