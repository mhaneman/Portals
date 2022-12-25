extends Area3D

@onready var timer = get_node("Timer")
@onready var label = get_node("Label")

func _ready():
	label.visible = false


func _on_body_entered(_body):
	label.visible = true
	timer.start()


func _on_timer_timeout():
	label.visible = false
