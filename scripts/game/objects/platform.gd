extends StaticBody3D
class_name Platform

@onready var points:Node3D = $points
@onready var end_point:Node3D = $points/end
@onready var start_point:Node3D = $points/start
@onready var spawns:Node3D = $spawns

@onready var spacing:Area3D = $spacing

func has_overlapping():
	await get_tree().physics_frame
	if spacing.has_overlapping_areas():
		return true
	return false


