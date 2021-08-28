extends KinematicBody2D

var velocity = Vector2(1.0, 1.0)
const MAX_SPEED = 400


func _physics_process(delta):
	# Mouse position for enemy to focus on
	var mouse_pos = get_viewport().get_mouse_position()
	
	# Vector towards the mouse
	var v = Vector2(position.x, position.y)
	velocity = v.direction_to(Vector2(mouse_pos))
	
	# Making ship point to the destination
	var ang = atan2(velocity.x, velocity.y)
	
	$EnemySprite.rotation = PI - ang
	
	move_and_collide(velocity * delta * MAX_SPEED)

