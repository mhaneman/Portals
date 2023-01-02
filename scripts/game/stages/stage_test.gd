extends StageBuilder

var flat_scene = preload("res://scenes/game_scene/platforms/flat.tscn")

func _ready():
	for __ in range(10):
		add_platform_to_path(flat_scene, Directions.straight, 2)
		
	
