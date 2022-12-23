extends Area3D

@onready var gamebus = get_node("/root/gamebus")


func _on_body_entered(_body):
	gamebus.emit_signal("portal_entered")
