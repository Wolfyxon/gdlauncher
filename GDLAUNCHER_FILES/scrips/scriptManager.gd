extends Node

var function_loops = true

func _physics_process(delta):
	if not function_loops: return
	if not get_children(): return
	for node in get_children():
		if node.has_method("_physics_process"):
			node.call("_physics_process",delta)
