extends Node3D

func is_colliding() -> bool:
	for i in self.get_children():
		if i.is_colliding():
			return true
	return false
