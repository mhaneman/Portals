extends Node
class_name StageBuilder

var rng = RandomNumberGenerator.new()

enum Directions {straight, left, right}
const MIN_DIST:float = 10

var instanced_platforms = []
var instanced_connectors = []
var instanced_items = []

@onready var current_end_point = self.global_position
var current_rotation:float = 0
var base_scale = 1

var connector_scene = preload("res://scenes/game_scene/platforms/connector.tscn")
var portal_scene = preload("res://scenes/game_scene/platforms/portal.tscn")

func add_random_platform(scenes):
	var direction:int = rng.randi_range(0, Directions.size() - 1)
	var type:int = rng.randi_range(0, scenes.size() - 1)
	await add_platform_to_path(scenes[type], direction, base_scale)
	
func add_platform_to_path(scene, direction:Directions, applied_scale:float, check_overlap=true):
	var instance = scene.instantiate()
	self.add_child(instance)
	instance.scale = Vector3(applied_scale, 1, 1)
	
	var connector
	
	if direction == Directions.straight:
		instance.global_position = current_end_point
		instance.rotate_y(current_rotation)
	else:
		connector = connector_scene.instantiate()
		self.add_child(connector) 
		connector.scale = Vector3(applied_scale, 1, applied_scale)
		connector.global_position = current_end_point
		connector.rotate_y(current_rotation) 
		
		if direction == Directions.left:
			instance.global_position = connector.left_connector.global_position
			instance.rotate_y(current_rotation + PI/2)
		elif direction == Directions.right:
			instance.global_position = connector.right_connector.global_position
			instance.rotate_y(current_rotation - PI/2)
		
	if await instance.has_overlapping() and check_overlap:
		instance.queue_free()
		if direction != Directions.straight:
			connector.queue_free()
		return
		
	current_end_point = instance.end_point.global_position
	if direction == Directions.left:
		current_rotation += PI / 2
	elif direction == Directions.right:
		current_rotation += -PI / 2
		
	instanced_platforms.push_back(instance)
	instanced_connectors.push_back(connector)
	
	return instance
	
func add_item_to_pos(item_scene, pos:Vector3):
	var instance = item_scene.instantiate()
	self.add_child(instance)
	instance.global_position = pos
	instanced_items.push_back(instance)
	
func add_items_to_platform(item_scene, platform):
	for j in platform.spawns.get_children():
		add_item_to_pos(item_scene, j.global_position)
