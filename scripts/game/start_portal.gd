extends Platform

@onready var start_portal_area = $start_portal_area
@onready var portal_mesh = $start_portal_area/CollisionShape3D/MeshInstance3D

const INIT_PORT_SIZE:float = 2.0
const PORTAL_DECAY_RATE:float = 0.13

var portal_size:float = INIT_PORT_SIZE
var wanted_portal_size:float = 1.0

var portal_color_red:float = 0.0
var wanted_portal_color_red:float = 0.0

# need to fix this 

func _ready():
	start_portal_area.body_entered.connect(_on_start_portal_entered)
	
func _on_start_portal_entered(_body):
	wanted_portal_size = 0
	wanted_portal_color_red = 1.0
	
func _process(_delta):
	portal_size = lerpf(portal_size, wanted_portal_size, PORTAL_DECAY_RATE)
	portal_color_red = lerpf(portal_color_red, wanted_portal_color_red, PORTAL_DECAY_RATE)
	
	portal_mesh.mesh.material.set_shader_parameter("size", portal_size)
	portal_mesh.mesh.material.set_shader_parameter("color", Color(portal_color_red, 0, 0))
