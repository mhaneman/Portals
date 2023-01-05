extends Node3D

@onready var gamebus = get_node("/root/gamebus")

var gen_scene = preload("res://scenes/game_scene/stages/stage_gen.tscn")

var stage_A
var stage_B

func _ready():
	gamebus.portal_entered.connect(_on_portal_entered)
	
	stage_A = gen_scene.instantiate()
	self.add_child(stage_A)
	
	stage_B = gen_scene.instantiate()
	stage_B.position = Vector3(10000, 10000, 10000)
	self.add_child(stage_B)

func _on_portal_entered():
	stage_A.queue_free()
	stage_A = stage_B
	stage_A.position = Vector3.ZERO
	
	stage_B = gen_scene.instantiate()
	stage_B.position = Vector3(10000, 10000, 10000)
	self.add_child(stage_B)
