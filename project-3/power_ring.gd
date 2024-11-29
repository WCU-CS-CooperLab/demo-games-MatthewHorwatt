extends Area3D

@export var invincibility_duration: float = 5.0

var move_x = false
var move_y = false

var move_amount = 2.5
var move_speed = 2.0

func _ready():
	#hide label initally
	#$Label3D.hide()
	pass




func _on_body_entered(body):
	if body.name == "Player":
		$CollisionShape3D/MeshInstance3D.hide()
		
		#shows invincability power up
		$Label3D.text = "Power Up!"
		$Label3D.modulate = Color(0.2,0.8,1.0)
		$Label3D.show()
		
		body.set_invincibility(invincibility_duration)
		
		#animate the label
		var tween = create_tween().set_parallel()
		tween.tween_property($Label3D, "position", Vector3(0, 10, 0), 1.0)
		tween.tween_property($Label3D, "modulate:a", 0.0,1.0)
		
		await tween.finished
		queue_free()
		
func _process(delta):
	$CollisionShape3D/MeshInstance3D.rotate_y(deg_to_rad(50) * delta)
	
	
	
