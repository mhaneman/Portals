extends Node3D

var stage_selection_item = preload("res://scenes/menu_scene/stage_selection/stage_selection_item.tscn")

var stage_types = [
	{"name": "normal", "albedo": Color(0, 0, 0) },
	{"name": "customize", "albedo": Color(0.36, 0.73, 0.64) },
	{"name": "advanced", "albedo": Color(0.80, 0.3, 0.33) },
	{"name": "disco", "albedo": Color(0.55, 0.3, 0.62) }
]

var quant_theta = PI / 2

func _ready():
	generate_circle()
		
func generate_circle():
	var theta_offset = 0
	for i in stage_types:
		add_stage(i.name, i.albedo, theta_offset)
		theta_offset += quant_theta
	
func add_stage(label, albedo, theta_offset):
	var stage = stage_selection_item.instantiate()
	self.add_child(stage)
	stage.mode_name.text = label
	stage.portal_area.set_portal_color(albedo)
	stage.content.position = Vector3(0, 8, -24)
	stage.rotate_y(theta_offset)
	
var theta = 0
var theta_quant = PI / 2
const ROTATE_SPEED = 0.02

func _process(_delta):
	if Input.is_action_just_pressed("left"):
		theta += theta_quant
	if Input.is_action_just_pressed("right"):
		theta += -theta_quant
	self.rotation.y = lerp_angle(self.rotation.y, theta, ROTATE_SPEED)
	
