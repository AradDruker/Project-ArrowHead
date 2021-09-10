extends Sprite

var enemy_A = preload("res://Assets/Characters/spaceShips_001.png")
var enemy_B = preload("res://Assets/Characters/spaceShips_002.png")
var enemy_C = preload("res://Assets/Characters/spaceShips_003.png")
var enemy_D = preload("res://Assets/Characters/spaceShips_004.png")
var enemy_E = preload("res://Assets/Characters/spaceShips_005.png")
var enemy_F = preload("res://Assets/Characters/spaceShips_006.png")
var enemy_G = preload("res://Assets/Characters/spaceShips_007.png")
var enemy_H = preload("res://Assets/Characters/spaceShips_008.png")
var enemy_I = preload("res://Assets/Characters/spaceShips_009.png")



# Called when the enemy enters the tree
func _ready():
	randomize()
	random_enemy()

# Chooses random enemy sprite (enemy type)
func random_enemy():
	var enemy_images = [enemy_A, enemy_B, enemy_C, enemy_D, enemy_E]
	var name = enemy_images[randi() % enemy_images.size()]
	self.texture = (name)
