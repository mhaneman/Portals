extends StageBuilder

var flat_scene = preload("res://scenes/game_scene/platforms/flat.tscn")
var square_scene = preload("res://scenes/game_scene/structures/square.tscn")

func _ready():
	await generate_platforms()
		
func generate_platforms():
	
	for ___ in range(3):
		for __ in range(5):
			await add_platform_to_path(flat_scene, Directions.straight, 1)
			
		await add_structure_to_path(square_scene, 0)
