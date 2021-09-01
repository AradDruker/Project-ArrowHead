extends KinematicBody2D

var velocity = Vector2(10.0,10.0)
const MAX_SPEED = 8
const ACCELERATION = 30
const FRICTION = 5

func _ready():
	position = Vector2(640.0, 360.0)

func _physics_process(delta):
	# Movement process / Input process
	var screen_size = get_viewport_rect().size
	
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
	else:
		velocity -= velocity * FRICTION * delta
	
	# Player stops instead of circling pointer
	#var dist = pow(pow(position.x - mouse_pos.x, 2) + pow(position.y - mouse_pos.y, 2), 0.5)
	#print(dist)
	#if dist < 55:
	#	velocity = Vector2.ZERO
	
	
	# Bumps player if hits wall
	var posx = position.x
	var posy = position.y
	if posy <= 37 or posy >= screen_size.y - 37 or posx <= 37 or posx >= screen_size.x - 37:
		velocity = velocity.rotated(PI/2)

	move_and_collide(velocity)
	
	# Keeps player in window
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

