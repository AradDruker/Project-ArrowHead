extends Sprite

var enemy_A = preload("res://Assets/Characters/enemy_A.png")
var enemy_B = preload("res://Assets/Characters/enemy_B.png")
var enemy_C = preload("res://Assets/Characters/enemy_C.png")
var enemy_D = preload("res://Assets/Characters/enemy_D.png")
var enemy_E = preload("res://Assets/Characters/enemy_E.png")

# Called when the enemy enters the tree
func _ready():
	randomize()
	random_enemy()

# Chooses random enemy sprite (enemy type)
func random_enemy():
	var enemy_images = [enemy_A, enemy_B, enemy_C, enemy_D, enemy_E]
	var name = enemy_images[randi() % enemy_images.size()]
	self.texture = (name)
