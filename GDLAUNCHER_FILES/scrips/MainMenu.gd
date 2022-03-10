extends Node


func _ready():
	pass


func _on_btn_browse_pressed():
	$pckSelect/FileDialog.popup()


func _on_FileDialog_file_selected(path):
	$pckSelect/path.text = path

func alert(text):
	$popup/alert.dialog_text = text
	$popup/alert.popup()

func _on_btn_launch_pressed():
	var d = Directory.new()
	if d.file_exists($pckSelect/path.text):
		print("IMPORTING PCK")
		if(ProjectSettings.load_resource_pack($pckSelect/path.text.replace("/","\\"),true)):
			$pckSelect/btn_launch.disabled = true
			$pckSelect/btn_browse.disabled = true
			
			
			#ProjectSettings.save_custom("user://tmpSe")
			
			print(ProjectSettings.get_setting("application/config/name"))
			InputMap.load_from_globals()
			yield(get_tree().create_timer(1),"timeout")
			#get_tree().change_scene("res://GDLAUNCHER_FILES/scenes/sceneLoader.tscn")
		else:
			alert("Error")
	else:
		alert("Cannot find file, make sure the path is valid")


func _on_btn_help_pressed():
	$pckSelect/btn_help/AcceptDialog.popup()
