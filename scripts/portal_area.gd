extends Area3D
@onready var gamebus = get_node("/root/gamebus")

# have random portal sizes
@onready var collision = get_node("CollisionShape3D")


func _on_body_entered(_body):
	gamebus.emit_signal("portal_entered")
