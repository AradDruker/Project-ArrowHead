extends KinematicBody2D

var velocity = Vector2(10.0,10.0)
const MAX_SPEED = 12
const ACCELERATION = 90
const FRICTION = 50
const FRICTION_2 = 40

signal game_over

func _ready():
	position = Vector2(640.0, 360.0)

func _physics_process(delta):
	#var screen_size = get_viewport_rect().size
	
	# Input Collection
	var input_vector = Vector2(position.x, position.y)
	var mouse_pos =  get_viewport().get_mouse_position()
	#input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	#input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	#input_vector = input_vector.normalized()
	input_vector = input_vector.direction_to(mouse_pos)
	
	# Player movement and head point
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED)
		var ang = atan2(velocity.x, velocity.y)
		$PlayerSprite.rotation = PI - ang
	
	#Player stops
	#else:
	#	velocity -= velocity * FRICTION * delta
	
	# Player slow to stop
	var dist = pow(pow(position.x - mouse_pos.x, 2) + pow(position.y - mouse_pos.y, 2), 0.5)
	if dist < 150 and dist >= 50:
		velocity = velocity * FRICTION * delta
	elif dist < 50 and dist >= 5:
		velocity = velocity * FRICTION_2 * delta
	elif dist < 5:
		velocity = Vector2.ZERO
	
	
	# Bumps player if hits wall
	var collision = move_and_collide(velocity)
	if collision:
		velocity = velocity.bounce(collision.normal)
		var collided_shape = collision.get_collider_shape()
		if collided_shape == null:
			Music.get_node("BorderBump").play()
		else:
			emit_signal("game_over")
	

