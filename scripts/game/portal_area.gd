extends Area3D
@onready var gamebus = get_node("/root/gamebus")

@onready var mesh_instance = $CollisionShape3D/MeshInstance3D
@onready var collision = get_node("CollisionShape3D")


func set_portal_color(albedo:Color):
	mesh_instance.mesh.material.set_shader_parameter("color", albedo)

# signals
func _on_body_entered(_body):
	gamebus.emit_signal("portal_entered")
