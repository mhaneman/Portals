extends Node3D

@onready var gamebus = get_node("/root/gamebus")

var tutorial_scene = preload("res://scenes/game_scene/stages/stage_tutorial.tscn")
var stage_scene = preload("res://scenes/game_scene/stages/stage_gen.tscn")
var test_scene = preload("res://scenes/game_scene/stages/stage_test.tscn")

var tutorial
var stage
var test

func _ready():
	gamebus.portal_entered.connect(_on_portal_entered)
	
	if gamebus.play_tutorial:
		test = test_scene.instantiate()
		self.add_child(test)
	else:
		stage = stage_scene.instantiate()
		self.add_child(stage)
	
# what an awful way to program this... NEED TO REFACTOR!!!
func _on_portal_entered():
	if gamebus.stage_number == 0 and gamebus.play_tutorial:
		test.queue_free()
		stage = stage_scene.instantiate()
		self.add_child(stage)
	else:
		stage.queue_free()
		stage = stage_scene.instantiate()
		self.add_child(stage)
