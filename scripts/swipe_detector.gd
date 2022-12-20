extends Node

signal swiped(direction:String)
var detect_radius:float = 100
var start_pos:Vector2
var can_detect:bool

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			start_pos = event.position
			can_detect = true

func _process(delta):
	if can_detect:
		var cur_pos:Vector2 = get_viewport().get_mouse_position()
		var disp:float = start_pos.distance_to(cur_pos)
		
		if disp >= detect_radius:
			end_detection(cur_pos)
			can_detect = false
			
func end_detection(end_pos:Vector2):
	var dis_x = start_pos.x - end_pos.x
	var dis_y = start_pos.y - end_pos.y
	
	if dis_x != 0 and abs(dis_y) / abs(dis_x) < 1:
		if (dis_x > 0):
			emit_signal("swiped", "left")
		else:
			emit_signal("swiped", "right")
	else:
		if (dis_y > 0):
			emit_signal("swiped", "up")
		else:
			emit_signal("swiped", "down")
