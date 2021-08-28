extends KinematicBody2D

var velocity = Vector2.ZERO
const MAX_SPEED = 10
const ACCELERATION = 30
const FRICTION = 5


func _ready():
	position = Vector2(640.0, 360.0)

func _physics_process(delta):
	var screen_size = get_viewport_rect().size
	# Input Collection
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED)
		var ang = atan2(velocity.x, velocity.y)
		print(rad2deg(ang))
		$ShipSprite.rotation = PI - ang
		
	
	else:
		velocity -= velocity * FRICTION * delta
	
	var posx = position.x
	var posy = position.y
	if posy <= 10 or posy >= screen_size.y - 10 or posx <= 10 or posx >= screen_size.x - 10:
		velocity = velocity.rotated(PI/2)
		
	move_and_collide(velocity)
	
	# Keeps player in window
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

