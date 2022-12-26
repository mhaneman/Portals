extends Node3D

enum Directions {straight, left, right}

var connector_scene = preload("res://scenes/game_scene/platforms/connector.tscn")
var flat_scene = preload("res://scenes/game_scene/platforms/flat.tscn")
var stair_scene = preload("res://scenes/game_scene/platforms/stair.tscn")
var gap_scene = preload("res://scenes/game_scene/platforms/gap.tscn")
var portal_scene = preload("res://scenes/game_scene/platforms/portal.tscn")

var firework_scene = preload("res://scenes/game_scene/items/firework.tscn")
var coin_scene = preload("res://scenes/game_scene/items/coin.tscn")
var notification_scene = preload("res://scenes/game_scene/items/notification.tscn")

var instanced_platforms = []
var instanced_connectors = []
var instanced_items = []
var current_end_point = Vector3.ZERO
var current_rotation:float = 0

@onready var gamebus = get_node("/root/gamebus")

func _ready():
	gamebus.portal_entered.connect(_on_portal_entered)
	tutorial()
	
func tutorial():
	for __ in range(5):
		add_platform_to_path(flat_scene, Directions.straight, 2)
	
	var p1 = add_platform_to_path(flat_scene, Directions.straight, 2)
	add_item_to_path(notification_scene, p1.get_node("spawns").get_child(0).global_position)
	
	add_platform_to_path(flat_scene, Directions.left, 2)
	for __ in range(3):
		add_platform_to_path(flat_scene, Directions.straight, 2)
		
	var p5 = add_platform_to_path(flat_scene, Directions.straight, 2)
	add_item_to_path(notification_scene, p5.get_node("spawns").get_child(0).global_position)
	
	for __ in range(3):
		add_platform_to_path(flat_scene, Directions.straight, 1)
	
	var p4 = add_platform_to_path(flat_scene, Directions.straight, 2)
	add_item_to_path(notification_scene, p4.get_node("spawns").get_child(0).global_position)
	
	add_platform_to_path(flat_scene, Directions.right, 1)
	
	for __ in range(3):
		var p2 = add_platform_to_path(flat_scene, Directions.straight, 1)
		for i in p2.get_node("spawns").get_children():
			add_item_to_path(coin_scene, i.global_position)
	
	add_platform_to_path(stair_scene, Directions.straight, 1)
	
	var p3 = add_platform_to_path(flat_scene, Directions.straight, 1)
	add_item_to_path(firework_scene, p3.get_node("spawns").get_child(0).global_position)
	
	add_platform_to_path(flat_scene, Directions.straight, 1)
	add_platform_to_path(gap_scene, Directions.straight, 1)
	add_platform_to_path(flat_scene, Directions.straight, 1)
	
	add_platform_to_path(portal_scene, Directions.straight, 1)
	
func add_item_to_path(item_scene, pos:Vector3):
	var instance = item_scene.instantiate()
	self.add_child(instance)
	instance.global_position = pos
	instanced_items.push_back(instance)

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
