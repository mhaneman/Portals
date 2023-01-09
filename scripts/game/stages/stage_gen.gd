extends StageBuilder

#platform scenes
var flat_scene = preload("res://scenes/game_scene/platforms/flat.tscn")
var stair_scene = preload("res://scenes/game_scene/platforms/stair.tscn")
var down_scene = preload("res://scenes/game_scene/platforms/down.tscn")

# item scenes
var coin_scene = preload("res://scenes/game_scene/items/coin.tscn")
var firework_scene = preload("res://scenes/game_scene/items/firework.tscn")
var totem_scene = preload("res://scenes/game_scene/items/totem.tscn")

# maybe rewrite this to have catagories of platforms instead of just general
# types


var down_scenes = [
	flat_scene,
	down_scene,
]
var up_scenes = [
	flat_scene,
	stair_scene,
]

@onready var gamebus = get_node("/root/gamebus")

func _init():
	pass

func _ready():
	generate()
	
func generate():
	await initalize_path()
	await generate_with_direction()
	await finalize_path()
	generate_items()
	
func initalize_path():
	await add_platform_to_path(start_portal_scene, Directions.straight, gamebus.base_scale, false)
	for __ in range(3):
		await add_platform_to_path(flat_scene, Directions.straight, gamebus.base_scale)
	
	
func finalize_path():
	await add_platform_to_path(flat_scene, Directions.straight, gamebus.base_scale)
	await add_platform_to_path(portal_scene, Directions.straight, 1.0, false)
	# need to set fall boundary
	
func generate_with_direction():
	var chosen
	for i in gamebus.stage_number + 3:
		if i == 0:
			chosen = down_scenes
		elif i % 10 == 0:
			chosen = down_scenes if rng.randi_range(0, 1) else up_scenes
	
		await generate_path(chosen)

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
	
func generate_path(scenes):
	var rand = rng.randi_range(0, 1000)
	if rand < 500:
		await add_random_spiral(scenes)
	elif rand < 700:
		await add_random_straight(scenes)
	else:
		await add_random_platform(scenes)
		
func add_random_straight(scenes):
	var type:int = rng.randi_range(0, scenes.size() - 1)
	await add_platform_to_path(scenes[type], Directions.straight, gamebus.base_scale)
	
		
func add_random_spiral(scenes):
	var direction = Directions.left if rng.randi_range(0, 1) else Directions.right
	var pieces = rng.randi_range(2, 6)
	var type:int = rng.randi_range(0, scenes.size() - 1)
	
	for __ in pieces:
		if rng.randi_range(0, 1):
			await add_platform_to_path(scenes[type], direction, gamebus.base_scale)
		else:
			await add_platform_to_path(scenes[type], Directions.straight, gamebus.base_scale)


func add_random_platform(scenes):
	var direction:int = rng.randi_range(0, Directions.size() - 1)
	var type:int = rng.randi_range(0, scenes.size() - 1)
	await add_platform_to_path(scenes[type], direction, gamebus.base_scale)
	
