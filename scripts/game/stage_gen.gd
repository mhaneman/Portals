extends Node3D

var rng = RandomNumberGenerator.new()

enum Directions {straight, left, right}
const MIN_DIST:float = 6


var connector_scene = preload("res://scenes/game_scene/platforms/connector.tscn")

#platform scenes
var flat_scene = preload("res://scenes/game_scene/platforms/flat.tscn")
var stair_scene = preload("res://scenes/game_scene/platforms/stair.tscn")
var down_scene = preload("res://scenes/game_scene/platforms/down.tscn")
var portal_scene = preload("res://scenes/game_scene/platforms/portal.tscn")


# item scenes
var coin_scene = preload("res://scenes/game_scene/items/coin.tscn")
var firework_scene = preload("res://scenes/game_scene/items/firework.tscn")

	
var down_scenes = [
	preload("res://scenes/game_scene/platforms/flat.tscn"),
	preload("res://scenes/game_scene/platforms/down.tscn"),
]

var up_scenes = [
	preload("res://scenes/game_scene/platforms/flat.tscn"),
	preload("res://scenes/game_scene/platforms/stair.tscn"),
]
	
var obstical_scenes = [
	preload("res://scenes/game_scene/obstacles/barrel.tscn")
]

var instanced_platforms = []
var instanced_connectors = []
var instanced_items = []
var current_end_point = Vector3.ZERO
var current_rotation:float = 0

@onready var gamebus = get_node("/root/gamebus")
func _ready():
	gamebus.portal_entered.connect(_on_portal_entered)
	
	generator()
	
func generator():
	initalize_path()
	generate_path(down_scenes)
	finalize_path()
	
	for i in instanced_connectors:
		for j in i.get_node("spawns").get_children():
			add_item_to_path(firework_scene, j.global_position)
			
	for i in instanced_platforms:
		for j in i.get_node("spawns").get_children():
			add_item_to_path(coin_scene, j.global_position)
			
func add_item_to_path(item_scene, pos:Vector3):
	var instance = item_scene.instantiate()
	self.add_child(instance)
	instance.global_position = pos
	instanced_items.push_back(instance)
	
func initalize_path():
	for __ in range(3):
		add_platform_to_path( flat_scene, Directions.straight, 1)
		
func finalize_path():
	var final = add_platform_to_path(portal_scene, Directions.straight, 1)
	
	if final.global_position.y < 0:
		gamebus.out_of_bounds_y_pos = final.global_position.y - 50
	else:
		gamebus.out_of_bounds_y_pos = -50
	
func generate_path(scenes):
	for __ in range(gamebus.stage_number * 2 + 3):
		add_random_platform(scenes)
	
# have scale go down with more platforms
func add_random_platform(scenes):
	var direction:int = rng.randi_range(0, Directions.size() - 1)
	var type:int = rng.randi_range(0, scenes.size() - 1)
	var applied_scale:float = 1
	var platform = add_platform_to_path(scenes[type], direction, applied_scale)
	
	# check distances here 
	#for i in instanced_platforms:
	#	var dist = platform.global_position.distance_to(i.global_position)
	#	if dist < MIN_DIST:
	#		pass

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
	
	
#signals 
func _on_portal_entered():
	
	for i in instanced_platforms:
		i.queue_free()
	instanced_platforms.clear()
	
	for i in instanced_connectors:
		i.queue_free()
	instanced_connectors.clear()
	
	for i in instanced_items:
		i.queue_free()
	instanced_items.clear()
	
	current_end_point = Vector3.ZERO
	current_rotation = 0
	
	gamebus.stage_number += 1
		
	generator()
