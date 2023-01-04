extends Node3D

var stage_selection_item = preload("res://scenes/menu_scene/stage_selection/stage_selection_item.tscn")

var stage_types = [
	{"name": "normal", "albedo": Color(1, 0, 0) },
	{"name": "challenge", "albedo": Color(0, 1, 0) },
	{"name": "advanced", "albedo": Color(0, 0, 1) },
	{"name": "disco", "albedo": Color(0, 0, 0) }
]

var quant_theta = PI / 2

func _ready():
	generate_circle()
		
func generate_circle():
	var theta = 0
	for i in stage_types:
		add_stage(i.name, i.albedo, theta)
		theta += quant_theta
	
func add_stage(label, albedo, theta):
	var stage = stage_selection_item.instantiate()
	self.add_child(stage)
	stage.mode_name.text = label
	stage.portal_area.set_portal_color(albedo)
	stage.content.position = Vector3(0, 10, -24)
	stage.rotate_y(theta)
	
var theta = PI/8
var theta_quant = PI / 2
const ROTATE_SPEED = 0.02
func _process(_delta):
	if Input.is_action_just_pressed("left"):
		theta += theta_quant
	if Input.is_action_just_pressed("right"):
		theta += -theta_quant
	self.rotation.y = lerp_angle(self.rotation.y, theta, ROTATE_SPEED)
	
