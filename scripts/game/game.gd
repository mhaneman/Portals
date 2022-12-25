extends Node3D


var tutorial_gen = preload("res://scenes/game_scene/stages/stage_tutorial.tscn")
var stage_gen = preload("res://scenes/game_scene/stages/stage_gen.tscn")

func _ready():
	var tutorial = tutorial_gen.instantiate()
	self.add_child(tutorial)
