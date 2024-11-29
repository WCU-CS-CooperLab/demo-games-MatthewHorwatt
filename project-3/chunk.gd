extends Node3D
var buildings = [
	preload("res://buildings/building_1.tscn"),
	preload("res://buildings/building_2.tscn"),
	preload("res://buildings/building_3.tscn"),
	preload("res://buildings/building_4.tscn"),
	preload("res://buildings/building_5.tscn"),
	]
var ring = preload("res://ring.tscn")
var power_ring = preload("res://power_ring.tscn")

var level = 0
	



func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()

func _ready():
	add_buildings()
	add_center_buildings()
	add_rings()

func add_buildings():
	for side in [-1, 1]:
		var zpos = -10
		for i in 18:
			if randf() > 0.75:
				zpos -= randi_range(5, 10)
				continue
			var nb = buildings[randi_range(0, buildings.size() -1)].instantiate()
			add_child(nb)
			nb.transform.origin.z = zpos
			nb.transform.origin.x = 20 * side
			zpos -= nb.get_node("MeshInstance3D").mesh.get_aabb().size.z

func add_center_buildings():
	if level > 0:
		for z in range (0, -200, -20):
			if randf() > 0.8:
				var nb = buildings[0].instantiate()
				add_child(nb)
				nb.position.z = z
				nb.position.x += 8
				nb.rotation.y = PI / 2

func add_rings():
	for z in range(0, -200, -10):
		if randf() > 0.76:
			var is_power_ring = randf() > 0.9
			var ring_instance = power_ring.instantiate() if is_power_ring else ring.instantiate()
			ring_instance.position.z = z
			ring_instance.position.y = randf_range(3, 17)
			match level:
				0: pass
				1:
					ring_instance.move_y = true
				2:
					ring_instance.position.x = randf_range(-10, 10)
					ring_instance.move_y = true
				3:
					ring_instance.position.x = randf_range(-10, 10)
					ring_instance.move_x = true
			add_child(ring_instance)
				
		
