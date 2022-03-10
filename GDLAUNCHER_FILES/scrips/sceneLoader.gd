extends Node

func _ready():
	yield(get_tree().create_timer(1),"timeout")
	$FileDialog.popup()

var selected = false
func _on_FileDialog_file_selected():
	selected = true
	print("Changing scene to: "+$FileDialog.current_file)
	get_tree().change_scene($FileDialog.current_file)

func _on_FileDialog_popup_hide():
	yield(get_tree().create_timer(0.1),"timeout")
	if not selected: get_tree().change_scene("res://GDLAUNCHER_FILES/scenes/GdLauncherMain.tscn")


func _on_FileDialog_confirmed():
	_on_FileDialog_file_selected()
