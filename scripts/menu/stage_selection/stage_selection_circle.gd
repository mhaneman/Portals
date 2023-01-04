extends Node3D

var stage_selection_item = preload("res://scenes/menu_scene/stage_selection/stage_selection_item.tscn")

var stage_types = [
	"normal",
	"challenge",
	"expert",
	"trippy"
]

var quant_theta = PI / 2

func _ready():
	generate_circle()
		
func generate_circle():
	var theta = 0
	for type in stage_types:
		add_stage(type, theta)
		theta += quant_theta
	
func add_stage(label, theta):
	var stage = stage_selection_item.instantiate()
	self.add_child(stage)
	stage.mode_name = label
	stage.content.position = Vector3(0, 10, -24)
	stage.rotate_y(theta)
	
	var t = Vector3(1, 2, 3)
	
var theta = PI/8
var theta_quant = PI / 2
const ROTATE_SPEED = 0.02
func _process(_delta):
	if Input.is_action_just_pressed("left"):
		theta += theta_quant
	if Input.is_action_just_pressed("right"):
		theta += -theta_quant
	self.rotation.y = lerp_angle(self.rotation.y, theta, ROTATE_SPEED)
	
