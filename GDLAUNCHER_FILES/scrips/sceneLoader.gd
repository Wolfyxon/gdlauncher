extends Node

func _ready():
	$appInfo/icon.texture = load(ProjectSettings.get_setting("application/config/icon"))
	$appInfo/name.text = ProjectSettings.get_setting("application/config/name")

var selected = false
func _on_FileDialog_file_selected():
	selected = true
	print("Changing scene to: "+$FileDialog.current_file)
	change_scene($FileDialog.current_file)


func _on_FileDialog_confirmed():
	_on_FileDialog_file_selected()


func _on_btn_scene_choose_pressed():
	$FileDialog.popup()


func _on_btn_scene_default_pressed():
	
	change_scene(ProjectSettings.get_setting("application/run/main_scene"))
	
func change_scene(path):
	$sceneChooser/btn_scene_default.disabled = true
	$sceneChooser/btn_scene_choose.disabled = true
	var err = get_tree().change_scene(path)
	if err != OK:
		$sceneChooser/btn_scene_default.disabled = false
		$sceneChooser/btn_scene_choose.disabled = false
		OS.alert("Error code: "+String(err)+"\n"+UtilsGd.get_error_name_from_code(err)+"\nGame might have missing resources or the PCK file is corrupted",\
		"Opening scene failed")
