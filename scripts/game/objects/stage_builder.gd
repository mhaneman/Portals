extends Node
class_name StageBuilder

var rng = RandomNumberGenerator.new()

enum Directions {straight, left, right}
const MIN_DIST:float = 6

var instanced_platforms = []
var instanced_connectors = []
var instanced_items = []

var current_end_point = Vector3.ZERO
var current_rotation:float = 0
var base_scale = 1

var connector_scene = preload("res://scenes/game_scene/platforms/connector.tscn")

# constructor
func _init():
	pass

func add_random_platform(scenes):
	var direction:int = rng.randi_range(0, Directions.size() - 1)
	var type:int = rng.randi_range(0, scenes.size() - 1)
	add_platform_to_path(scenes[type], direction, base_scale)
	
func add_platform_to_path(scene, direction:Directions, applied_scale:float):
	var instance = scene.instantiate()
	self.add_child(instance)
	instanced_platforms.push_back(instance)
	
	instance.scale = Vector3(applied_scale, 1, 1)
	
	if direction == Directions.straight:
		instance.global_position = current_end_point
		instance.rotate_y(current_rotation)
		current_end_point = instance.get_node("end_point").global_position
		return instance
		
	var connector = connector_scene.instantiate()
	self.add_child(connector) 
	instanced_connectors.push_back(connector)
	connector.scale = Vector3(applied_scale, 1, applied_scale)
	connector.global_position = current_end_point
	connector.rotate_y(current_rotation) 
	
	if direction == Directions.left:
		instance.global_position = connector.get_node("connectors/left").global_position
		current_rotation += PI / 2
	elif direction == Directions.right:
		instance.global_position = connector.get_node("connectors/right").global_position
		current_rotation += -PI / 2
		
	instance.rotate_y(current_rotation)
	current_end_point = instance.get_node("end_point").global_position
	return instance
	
func add_item_to_path(item_scene, platform):
	var instance = item_scene.instantiate()
	self.add_child(instance)
	instance.global_position = platform.global_position
	instanced_items.push_back(instance)
