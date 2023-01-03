extends StageBuilder

var flat_scene = preload("res://scenes/game_scene/platforms/flat.tscn")

func _ready():
	for __ in range(5):
		await add_platform_to_path(flat_scene, Directions.straight, 2)
		
	for __ in range(0, 3):
		await add_platform_to_path(flat_scene, Directions.left, 2)
		
	
