extends Node3D
class_name Structure

@onready var spacing:Area3D = $spacing

@onready var straights = $points/straights
@onready var lefts = $points/lefts
@onready var rights =$points/rights
@onready var backs = $points/backs

func has_overlapping():
	await get_tree().physics_frame
	if spacing.has_overlapping_areas():
		return true
	return false
