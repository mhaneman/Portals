extends StageBuilder

#platform scenes
var flat_scene = preload("res://scenes/game_scene/platforms/flat.tscn")
var stair_scene = preload("res://scenes/game_scene/platforms/stair.tscn")
var down_scene = preload("res://scenes/game_scene/platforms/down.tscn")
var portal_scene = preload("res://scenes/game_scene/platforms/portal.tscn")

# item scenes
var coin_scene = preload("res://scenes/game_scene/items/coin.tscn")
var firework_scene = preload("res://scenes/game_scene/items/firework.tscn")
var totem_scene = preload("res://scenes/game_scene/items/totem.tscn")

var down_scenes = [
	flat_scene,
	down_scene
]

var up_scenes = [
	flat_scene,
	stair_scene
]

@onready var gamebus = get_node("/root/gamebus")

func _ready():
	gamebus.portal_entered.connect(_on_portal_entered)
	generate()
	
func generate():
	initalize_path()
	
	var chosen
	for i in gamebus.stage_number + 3:
		if i % 10 == 0:
			chosen = down_scenes if rng.randi_range(0, 1) else up_scenes
		generate_path(chosen)
		
	finalize_path()
	generate_items()

func generate_items():
	for i in instanced_connectors:
		var rand = rng.randi_range(0, 1000)
		if rand < 5:
			for j in i.get_node("spawns").get_children():
				add_item_to_path(totem_scene, j)
		elif rand < 120:
			for j in i.get_node("spawns").get_children():
				add_item_to_path(firework_scene, j)
			

	for i in instanced_platforms:
		if rng.randi_range(0, 3) == 0:
			for j in i.get_node("spawns").get_children():
				add_item_to_path(coin_scene, j)
	
func initalize_path():
	for __ in range(3):
		add_platform_to_path( flat_scene, Directions.straight, base_scale)
		
func finalize_path():
	var final = add_platform_to_path(portal_scene, Directions.straight, 1.0)
	
	if final.global_position.y < 0:
		gamebus.out_of_bounds_y_pos = final.global_position.y - 50
	else:
		gamebus.out_of_bounds_y_pos = -50
	
func generate_path(scenes):
	var rand = rng.randi_range(0, 1000)
	if rand < 300:
		add_random_spiral(scenes)
	elif rand < 700:
		add_random_straight(scenes)
	else:
		add_random_platform(scenes)
		
func add_random_straight(scenes):
	var type:int = rng.randi_range(0, scenes.size() - 1)
	add_platform_to_path(scenes[type], Directions.straight, base_scale)
	
		
func add_random_spiral(scenes):
	var direction = Directions.left if rng.randi_range(0, 1) else Directions.right
	var pieces = rng.randi_range(2, 6)
	var type:int = rng.randi_range(0, scenes.size() - 1)
	
	for __ in pieces:
		if rng.randi_range(0, 1):
			add_platform_to_path(scenes[type], direction, base_scale)
		else:
			add_platform_to_path(scenes[type], Directions.straight, base_scale)
	
#signals 
func _on_portal_entered():
	
	gamebus.stage_number += 1
	gamebus.base_scale = clampf(1.5 - gamebus.stage_number * 0.05, 0.8, 1.5)
