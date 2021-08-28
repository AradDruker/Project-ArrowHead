extends KinematicBody2D

var velocity = Vector2(1.0, 1.0)
const MAX_SPEED = 100
const ACCELERATION =  10
var player_pos


func player_details(pos):
	player_pos = pos




func _physics_process(delta):
	# Mouse position for enemy to focus on
	
	# Vector towards the mouse
	var v = Vector2(position.x, position.y)
	v = v.direction_to(Vector2(player_pos))
	velocity +=  v.normalized() * ACCELERATION
	
	# Making ship point to the destination
	var ang = atan2(velocity.x, velocity.y)
	$EnemySprite.rotation = PI - ang
	
	if pow(pow(position.x - player_pos.x, 2) + pow(position.y - player_pos.y, 2), 0.5) > 3:
	
		move_and_collide(velocity * delta * MAX_SPEED)

