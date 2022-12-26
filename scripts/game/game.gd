extends Node3D

@onready var gamebus = get_node("/root/gamebus")

var tutorial_gen = preload("res://scenes/game_scene/stages/stage_tutorial.tscn")
var stage_gen = preload("res://scenes/game_scene/stages/stage_gen.tscn")

var tutorial
var stage
var i = 0

func _ready():
	gamebus.portal_entered.connect(_on_portal_entered)
	
	tutorial = tutorial_gen.instantiate()
	self.add_child(tutorial)
	
func _on_portal_entered():
	if i == 0:
		tutorial.queue_free()
		stage = stage_gen.instantiate()
		self.add_child(stage)
	i += 1
