extends StageBuilder

var flat_scene = preload("res://scenes/game_scene/platforms/flat.tscn")
var stair_scene = preload("res://scenes/game_scene/platforms/stair.tscn")
var down_scene = preload("res://scenes/game_scene/platforms/down.tscn")
var gap_scene = preload("res://scenes/game_scene/platforms/gap.tscn")
var portal_scene = preload("res://scenes/game_scene/platforms/portal.tscn")

var firework_scene = preload("res://scenes/game_scene/items/firework.tscn")
var coin_scene = preload("res://scenes/game_scene/items/coin.tscn")
var notification_scene = preload("res://scenes/game_scene/items/notification.tscn")

@onready var gamebus = get_node("/root/gamebus")

func _ready():
	gamebus.portal_entered.connect(_on_portal_entered)
	tutorial()
	
func tutorial():
	for __ in range(3):
		add_platform_to_path(flat_scene, Directions.straight, 2)
		
	for __ in range(2):
		add_platform_to_path(down_scene, Directions.straight, 2)
		
	# notify player of firework
	var p5 = add_platform_to_path(flat_scene, Directions.straight, 2)
	add_item_to_pos(notification_scene, p5.get_node("spawns").get_child(0).global_position)
		
	for __ in range(2):
		add_platform_to_path(flat_scene, Directions.straight, 2)
	
	# spawn firework
	var p3 = add_platform_to_path(flat_scene, Directions.straight, 2)
	add_item_to_pos(firework_scene, p3.get_node("spawns").get_child(0).global_position)
	
	for __ in range(2):
		add_platform_to_path(flat_scene, Directions.straight, 2)
	add_platform_to_path(gap_scene, Directions.straight, 2)
	add_platform_to_path(flat_scene, Directions.straight, 2)
	
	#notify player of turning
	var p1 = add_platform_to_path(flat_scene, Directions.straight, 2)
	add_item_to_pos(notification_scene, p1.get_node("spawns").get_child(0).global_position)
	
	add_platform_to_path(flat_scene, Directions.left, 2)
	for __ in range(3):
		add_platform_to_path(flat_scene, Directions.straight, 2)
	
	for __ in range(3):
		add_platform_to_path(flat_scene, Directions.straight, 2)
	
	var p4 = add_platform_to_path(flat_scene, Directions.straight, 2)
	add_item_to_pos(notification_scene, p4.get_node("spawns").get_child(0).global_position)
	
	add_platform_to_path(flat_scene, Directions.right, 2)
	
	for __ in range(3):
		var p2 =add_platform_to_path(flat_scene, Directions.straight, 2)
		add_items_to_platform(coin_scene, p2)
	
	add_platform_to_path(portal_scene, Directions.straight, 1)


func _on_portal_entered():
	gamebus.stage_number += 1
