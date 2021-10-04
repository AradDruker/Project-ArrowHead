extends KinematicBody2D

export (PackedScene) var World



var velocity = Vector2(10.0,10.0)
const MAX_SPEED = 12
const ACCELERATION = 90
const FRICTION_0 = 55
const FRICTION_1 = 50
const FRICTION_2 = 45
const FRICTION_3 = 40
onready var MOVE = true
onready var STATE = -1 # 0 for normal movement 1 for un controlled movement
var player_pressed = false
var swipe_start_position = Vector2()
var pull_vector = Vector2()
var continue_move_after_state_one = false
var pulling
var shielded = false
var shield_hit = false

signal game_over
signal coin_collected

func _ready():
	position = Vector2(640.0, 360.0)
	

func _physics_process(delta):
	if STATE == 0:
		
		# Player Follows the mouse/pointer
		# Input Collection - Player follows pointer.
		
		var input_vector = Vector2(position.x, position.y)
		var mouse_pos =  get_viewport().get_mouse_position()
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
		if dist >= 240:
			velocity += input_vector * ACCELERATION * delta
		elif dist < 240 and dist >= 200:
			velocity = velocity * FRICTION_0 * delta
		elif dist < 200 and dist >= 160:
			velocity = velocity * FRICTION_1 * delta
		elif dist < 160 and dist >= 120:
			velocity = velocity * FRICTION_2 * delta
		elif dist < 120 and dist >= 80:
			velocity = velocity * FRICTION_3 * delta
		elif dist < 80:
			velocity = Vector2.ZERO

		
		# Bumps player if hits wall
		var collision = move_and_collide(velocity)
		# Coliison check
		if collision:
			var collided_shape = collision.get_collider_shape()
			if collided_shape == null:
				Music.get_node("BorderBump").play()
				velocity = velocity.bounce(collision.normal) * 1.5
#				MOVE = false
				STATE = 1
				# For logic purposes 
				continue_move_after_state_one = true
			else:
				collision_no_walls(collision)
	
	elif STATE == 1:
		#Player can't control the movement
		# Happens When the player bumps the walls
		# Or when the player uses the pulling feature
		
		velocity = velocity * FRICTION_0 * delta
		var ang = atan2(velocity.x, velocity.y)
		$PlayerSprite.rotation = PI - ang
		var collision = move_and_collide(velocity)
		if velocity.length() < 15 and continue_move_after_state_one:
			STATE = 0
			continue_move_after_state_one = false
			pulling = false
			
		# Coliison check
		if collision:
			var collided_shape = collision.get_collider_shape()
			if collided_shape == null:
				Music.get_node("BorderBump").play()
				velocity = velocity.bounce(collision.normal)
				var MAX_SPEED_state_1 = 30
				velocity = velocity.clamped(MAX_SPEED_state_1)
				if not pulling:
					continue_move_after_state_one = true
			else:
				collision_no_walls(collision)
					
	elif STATE == -1:
		var ang = atan2(velocity.x, velocity.y)
		$PlayerSprite.rotation = ang
		velocity = Vector2.ZERO
		var collision = move_and_collide(velocity)
		if collision:
			var collided_shape = collision.get_collider_shape()
			if collided_shape == null:
				Music.get_node("BorderBump").play()
				velocity = velocity.bounce(collision.normal)
				var MAX_SPEED_state_1 = 30
				velocity = velocity.clamped(MAX_SPEED_state_1)
				if not pulling:
					continue_move_after_state_one = true
			else:
				collision_no_walls(collision)

	elif STATE == -2:
		velocity = Vector2.ZERO
		$PlayerSprite.rotation = get_global_mouse_position().angle_to_point(position) + PI / 2
		var collision = move_and_collide(velocity)
		if velocity.length() < 15 and continue_move_after_state_one:
			STATE = 0
			continue_move_after_state_one = false
			pulling = false
			
		# Coliison check
		if collision:
			var collided_shape = collision.get_collider_shape()
			if collided_shape == null:
				Music.get_node("BorderBump").play()
				velocity = velocity.bounce(collision.normal)
				var MAX_SPEED_state_1 = 30
				velocity = velocity.clamped(MAX_SPEED_state_1)
				if not pulling:
					continue_move_after_state_one = true
			else:
				collision_no_walls(collision)


func collision_no_walls(collisionObject):
	if "Coin" in collisionObject.collider.name:
		emit_signal("coin_collected")
		Music.get_node("CoinPick").play()
		var object_id = collisionObject.collider_id
		instance_from_id(object_id).queue_free()
		return "Coin"
	elif "Shield" in collisionObject.collider.name:
		shielded = true
		$Shield.visible = true
		$Shield/ShieldTimer.start()
		instance_from_id(collisionObject.collider_id).queue_free()
		set_collision_mask_bit(2, false)
		return "Shield"
	elif not shielded:
		emit_signal("game_over")

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.position.distance_to(self.position) < 50 and not player_pressed and velocity == Vector2.ZERO:
				print("Pressed")
				player_pressed = true
				swipe_start_position = self.position
#				print(swipe_start_position)
				STATE = -2
			else:
				if STATE != 1:
					STATE = 0
				else:
					continue_move_after_state_one = true
		else:
			if player_pressed:
				print("Released")
				var pointer_drag = event.position
#				print(pointer_drag)
				velocity = (pointer_drag - swipe_start_position) * -0.15
				velocity = velocity.rotated(PI)
				STATE = 1
				player_pressed = false
				pulling = true


func _on_ShieldTimer_timeout():
	$Shield/TimerOneSecLeft.start()
	$Shield/ShieldAnimator.play("Shield")
	shield_hit = true
	


func _on_TimerOneSecLeft_timeout():
	set_collision_mask_bit(2, true)
	$Shield.visible = false
	shielded = false
	shield_hit = false


func _on_PlayerArea_body_entered(body):
	if shielded:
		if 'Enemy' in body.name and not shield_hit:
			shield_hit = true
			$Shield/ShieldTimer.stop()
			$Shield/ShieldAnimator.play("Shield")
			$Shield/TimerOneSecLeft.start()
