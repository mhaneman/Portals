extends Area3D

const ROT_SPEED = 3

func _ready():
	pass

func _process(delta):
	self.rotate_y(-delta * ROT_SPEED)


func _on_body_entered(_body):
	# do some kind of animation
	self.visible = false
