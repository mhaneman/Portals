extends Node3D

var rng = RandomNumberGenerator.new()

enum Directions {straight, left, right}
const MIN_DIST:float = 6


var connector_scene = preload("res://scenes/game_scene/platforms/connector.tscn")
var flat_scene = preload("res://scenes/game_scene/platforms/flat.tscn")
var stair_scene = preload("res://scenes/game_scene/platforms/stair.tscn")
var down_scene = preload("res://scenes/game_scene/platforms/down.tscn")
var portal_scene = preload("res://scenes/game_scene/platforms/portal.tscn")

var plat_scenes = [
	preload("res://scenes/game_scene/platforms/flat.tscn"),
	#preload("res://scenes/game_scene/platforms/stair.tscn"),
	preload("res://scenes/game_scene/platforms/down.tscn"),
	#preload("res://scenes/game_scene/platforms/gap.tscn"),
	# preload("res://scenes/game_scene/platforms/up.tscn"),
	]
	
var obstical_scenes = [
	preload("res://scenes/game_scene/obstacles/barrel.tscn")
]

var instanced_platforms = []
var instanced_connectors = []
var current_end_point = Vector3.ZERO
var current_rotation:float = 0
var current_scale = Vector3.ONE

var stage_number:int = 0

func _on_portal_entered():
	
	for i in instanced_platforms:
		i.queue_free()
	instanced_platforms.clear()
	
	for i in instanced_connectors:
		i.queue_free()
	instanced_connectors.clear()
	
	current_end_point = Vector3.ZERO
	current_rotation = 0
	current_scale = Vector3.ONE
	
	stage_number += 1
		
	generator()

func _ready():
	var gamebus = get_node("/root/gamebus")
	gamebus.portal_entered.connect(_on_portal_entered)
	
	generator()
	
func generator():
	initalize_path()
	generate_path(stage_number)
	finalize_path()
	
func initalize_path():
	for __ in range(3):
		add_platform_to_path(Directions.straight, Vector3.ONE, flat_scene)
		
func finalize_path():
	add_platform_to_path(Directions.straight, Vector3.ONE, portal_scene)
	
func generate_path(stage_number:int):
	# generate_spiral()
	# generate_flat_obsticals()
	for __ in range(stage_number * 2 + 3):
		add_random_platform()
		
func generate_spiral():
	for __ in range(4):
		add_platform_to_path(rng.randi_range(1, 2), Vector3.ONE, down_scene)
		add_platform_to_path(Directions.straight, Vector3.ONE, down_scene)
		
	for __ in range(4):
		add_platform_to_path(Directions.left, Vector3.ONE, down_scene)
		
func generate_flat_obsticals():
	for __ in range(6):
		var platform = add_platform_to_path(Directions.straight, Vector3.ONE, flat_scene)
		add_obsticals_to_flat(platform)
		
func add_obsticals_to_flat(platform):
	var end = platform.get_node("end_point").global_position
	var disp = platform.global_position - end
	var density = 2
	
	for i in range(0, density):
		var obstical = obstical_scenes[0].instantiate()
		self.add_child(obstical)
		obstical.global_position = platform.global_position + i * (disp / density)
		obstical.rotate_y(current_rotation)
	
# keep platform generation in area
func add_random_platform():
	var direction:int = rng.randi_range(0, Directions.size() - 1)
	var type:int = rng.randi_range(0, plat_scenes.size() - 1)
	var applied_scale = Vector3.ONE
	var platform = add_platform_to_path(direction, applied_scale, type)
	
	# check distances here 
	for i in instanced_platforms:
		var dist = platform.global_position.distance_to(i.global_position)
		if dist < MIN_DIST:
			print(dist)

func add_platform_to_path(direction:Directions, applied_scale:Vector3, type=0):
	var instance
	if typeof(type) == TYPE_INT:
		instance = plat_scenes[type].instantiate()
	else:
		instance = type.instantiate()
	self.add_child(instance)
	instanced_platforms.push_back(instance)
	
	instance.scale = applied_scale
	
	if direction == Directions.straight:
		instance.global_position = current_end_point
		instance.rotate_y(current_rotation)
		current_end_point = instance.get_node("end_point").global_position
		return instance
		
	var connector = connector_scene.instantiate()
	self.add_child(connector) 
	instanced_connectors.push_back(connector)
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
