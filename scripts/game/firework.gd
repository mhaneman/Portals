extends Area3D

@onready var gamebus = get_node("/root/gamebus") 


func _on_body_entered(_body):
	# do some kind of animation
	gamebus.collected_fireworks += 1
	self.visible = false
