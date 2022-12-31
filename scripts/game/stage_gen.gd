extends StageBuilder

#platform scenes
var flat_scene = preload("res://scenes/game_scene/platforms/flat.tscn")
var stair_scene = preload("res://scenes/game_scene/platforms/stair.tscn")
var down_scene = preload("res://scenes/game_scene/platforms/down.tscn")

# item scenes
var coin_scene = preload("res://scenes/game_scene/items/coin.tscn")
var firework_scene = preload("res://scenes/game_scene/items/firework.tscn")
var totem_scene = preload("res://scenes/game_scene/items/totem.tscn")

var down_scenes = [
	flat_scene,
	down_scene,
]

var up_scenes = [
	flat_scene,
	stair_scene,
]

const INIT_PLAT_SIZE:float = 2.0
const MIN_PLAT_SIZE:float = 0.6
const OOB_DISPL:float = -50.0

@onready var gamebus = get_node("/root/gamebus")

func _ready():
	gamebus.portal_entered.connect(_on_portal_entered)
	generate()
	
func generate():
	# initalize path
	for __ in range(3):
		add_platform_to_path(flat_scene, Directions.straight, base_scale)
	
	var chosen
	for i in gamebus.stage_number + 3:
		if i % 10 == 0:
			chosen = down_scenes if rng.randi_range(0, 1) else up_scenes
		generate_path(chosen)
		
	finalize_path()
	generate_items()

func generate_items():
	# refactor nested loops
	for i in instanced_connectors:
		var rand = rng.randi_range(0, 1000)
		if rand < 5:
			add_items_to_platform(totem_scene, i)
		elif rand < 120:
			add_items_to_platform(firework_scene, i)
			
	for i in instanced_platforms:
		if rng.randi_range(0, 3) == 0:
			add_items_to_platform(coin_scene, i)
	

func finalize_path():
	var final = add_platform_to_path(portal_scene, Directions.straight, 1.0)
	
	#need to fix this since we now go up and down ...
	if final.global_position.y < 0:
		gamebus.out_of_bounds_y_pos = final.global_position.y + OOB_DISPL
	else:
		gamebus.out_of_bounds_y_pos = OOB_DISPL
	
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
	
# signals 
func _on_portal_entered():
	gamebus.stage_number += 1
	gamebus.base_scale = clampf( \
		INIT_PLAT_SIZE - gamebus.stage_number * 0.05, \
		MIN_PLAT_SIZE, INIT_PLAT_SIZE)
