extends Node3D

var rng = RandomNumberGenerator.new()

var connector_scene = preload("res://scenes/game_scene/platforms/connector.tscn")
var flat_scene = preload("res://scenes/game_scene/platforms/flat.tscn")
var portal_scene = preload("res://scenes/game_scene/platforms/portal.tscn")

var plat_scenes = [
	preload("res://scenes/game_scene/platforms/flat.tscn"),
	preload("res://scenes/game_scene/platforms/stair.tscn"),
	preload("res://scenes/game_scene/platforms/gap.tscn"),
	]

var current_end_point = Vector3.ZERO

func _ready():
	initalize_path()
	generate_path()
	finalize_path()
	
func initalize_path():
	add_portal_to_path()
	for __ in range(3):
		add_flat_to_path()
		
func finalize_path():
	add_portal_to_path()
	
func generate_path():
	add_platform_to_path(1, "straight")
	add_platform_to_path(1, "left")
	add_platform_to_path(1, "left")
	
func add_portal_to_path():
	var instance = portal_scene.instantiate()
	self.add_child(instance)
	instance.global_position = current_end_point
	current_end_point = instance.get_node("end_point").global_position
		
func add_flat_to_path():
	var instance = flat_scene.instantiate()
	self.add_child(instance)
	instance.global_position = current_end_point
	current_end_point = instance.get_node("end_point").global_position

func add_platform_to_path(type, direction):
	var instance = plat_scenes[type].instantiate()
	var connector = connector_scene.instantiate()
	self.add_child(connector) 
	self.add_child(instance)
	
	connector.global_position = current_end_point
	
	if direction == "left":
		instance.global_position = connector.get_node("connectors/left").global_position
		instance.rotate_y(PI / 2)
	elif direction == "right":
		instance.global_position = connector.get_node("connectors/right").global_position
		instance.rotate_y(-PI / 2)
	else:
		instance.global_position = connector.get_node("connectors/back").global_position
	
	current_end_point = instance.get_node("end_point").global_position

