extends CharacterBody3D

signal dead
signal score_changed
signal fuel_changed

@export var pitch_speed = 1.1
@export var roll_speed = 2.5
@export var level_speed = 4.0
@export var forward_speed = 25
@export var fuel_burn = 1.0
@export var plane_speed = forward_speed
@export var speed_increase_rate = 1.0

var roll_input = 0
var pitch_input = 0
var max_altitude = 20
var max_fuel = 10.0
var fuel = 10.0: set = set_fuel
var score = 0: set = set_score
var is_invincible = false
var invincibility_timer = null



func get_input(delta):
	pitch_input = Input.get_axis("pitch_down", "pitch_up")
	roll_input = Input.get_axis("roll_left", "roll_right")
	if position.y >= max_altitude and pitch_input > 0:
		position.y = max_altitude
		pitch_input = 0

func _physics_process(delta):
	get_input(delta)
	
	plane_speed += speed_increase_rate * delta
	#distance_flown += plane_speed * delta
	rotation.x = lerpf(rotation.x, pitch_input, pitch_speed * delta)
	rotation.x = clamp(rotation.x, deg_to_rad(-45), deg_to_rad(45))
	$cartoon_plane.rotation.z = lerpf($cartoon_plane.rotation.z,roll_input, roll_speed * delta)
	velocity = -transform.basis.z * forward_speed
	velocity += transform.basis.x * $cartoon_plane.rotation.z / deg_to_rad(45) * forward_speed / 2.0
	
	move_and_slide()
	if get_slide_collision_count() > 0:
		die()
	fuel -= fuel_burn * delta
	plane_speed += speed_increase_rate * delta
	
		

func die():
	set_physics_process(false)
	$cartoon_plane.hide()
	$Explosion.show()
	$Explosion.play("default")
	await $Explosion.animation_finished
	dead.emit()
	var title_screen = "res://title_screen.tscn"
	 
	
func set_fuel(value):
	fuel = min(value, max_fuel)
	fuel_changed.emit(fuel)
	if fuel <= 0:
		die()

func set_score(value):
	score = value 
	score_changed.emit(score)
	
func set_invincibility(duration):
	is_invincible = true
	if invincibility_timer:
		invincibility_timer.stop()
	else:
		invincibility_timer = Timer.new()
		add_child(invincibility_timer)
		invincibility_timer.connect("timeout", self, "_on_invincibility_end")
	invincibility_timer.start(duration)

func _on_invincibility_end():
	is_invincible = false
	invincibility_timer.queue_free()
	invincibility_timer = null
	
	
	
