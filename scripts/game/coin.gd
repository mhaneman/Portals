extends Area3D

@onready var gamebus = get_node("/root/gamebus") 
const ROT_SPEED = 3

func _ready():
	pass

func _process(delta):
	self.rotate_y(-delta * ROT_SPEED)


func _on_body_entered(_body):
	# do some kind of animation
	gamebus.current_collected_coins += 1
	print(gamebus.current_collected_coins)
	self.visible = false
