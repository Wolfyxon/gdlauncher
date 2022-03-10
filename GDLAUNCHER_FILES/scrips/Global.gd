extends Node

var scripts = []

func _physics_process(delta):
	if not(get_tree().current_scene.has_node("gdLauncherPanel")):
		var panel = preload("res://GDLAUNCHER_FILES/scenes/gdLauncherPanel.tscn").instance()
		get_tree().current_scene.add_child(panel)
