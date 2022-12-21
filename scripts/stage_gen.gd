extends Node3D

var rng = RandomNumberGenerator.new()

enum Directions {straight, left, right}
const MIN_DIST:float = 6


var connector_scene = preload("res://scenes/game_scene/platforms/connector.tscn")
var flat_scene = preload("res://scenes/game_scene/platforms/flat.tscn")
var portal_scene = preload("res://scenes/game_scene/platforms/portal.tscn")

var plat_scenes = [
	preload("res://scenes/game_scene/platforms/flat.tscn"),
	preload("res://scenes/game_scene/platforms/stair.tscn"),
	]
	
var obstical_scenes = [
	preload("res://scenes/game_scene/obstacles/barrel.tscn")
]

var instanced_platforms = []
var current_end_point = Vector3.ZERO
var current_rotation:float = 0

func _ready():
	initalize_path()
	generate_path()
	finalize_path()
	
func initalize_path():
	add_platform_to_path(Directions.straight, portal_scene)
	for __ in range(3):
		add_platform_to_path(Directions.straight, flat_scene)
		
func finalize_path():
	add_platform_to_path(Directions.straight, portal_scene)
	
func generate_path():
	for __ in range(30):
		add_platform()
	
func add_platform():
	var direction:int = rng.randi_range(0, Directions.size() - 1)
	var type:int = rng.randi_range(0, plat_scenes.size() - 1)
	var platform = add_platform_to_path(direction, type)
	
	# check distances here 
	for i in instanced_platforms:
		var dist = platform.global_position.distance_to(i.global_position)
		if dist < MIN_DIST:
			print(dist)
	
	# summon entites
	# add obsticals if flat
	# add_obsticals(platform)
	
	instanced_platforms.push_back(platform)

func add_obsticals(platform):
	var obstical = obstical_scenes[0].instantiate()
	self.add_child(obstical)
	obstical.global_position = platform.global_position
	obstical.rotate_y(current_rotation)


func add_platform_to_path(direction:Directions, type=0):
	var instance
	if typeof(type) == TYPE_INT:
		instance = plat_scenes[type].instantiate()
	else:
		instance = type.instantiate()
		
	self.add_child(instance)
	
	if direction == Directions.straight:
		instance.global_position = current_end_point
		instance.rotate_y(current_rotation)
		current_end_point = instance.get_node("end_point").global_position
		return instance
		
	var connector = connector_scene.instantiate()
	self.add_child(connector) 
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
