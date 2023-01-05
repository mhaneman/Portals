extends StageBuilder

var flat_scene = preload("res://scenes/game_scene/platforms/flat.tscn")
var house_scene = preload("res://scenes/game_scene/envi/house.tscn")

func _ready():
	await generate_platforms()
	add_house()
	
	
func add_house():
	var last_plat:Vector3 = instanced_platforms[-1].global_position
	var house = house_scene.instantiate()
	self.add_child(house)
	house.global_position = last_plat
		
func generate_platforms():
	
	for ___ in range(3):
		for __ in range(5):
			await add_platform_to_path(flat_scene, Directions.straight, 1)
			
		for __ in range(0, 3):
			await add_platform_to_path(flat_scene, Directions.left, 1)
