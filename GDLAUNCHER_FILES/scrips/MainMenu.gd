extends Node

var chars = "`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\\|aAsSdDfFgGhHJkKlL;:'\"zZxXcCvVbBnNmM,<.>/?]\n "

func _ready():
	pass

func parse_and_load_settings(path):
	var file = File.new()
	file.open(path, File.READ)
	var header = file.get_buffer(4)
	print("header:", header)
	var count = file.get_32()
	print("entries:", count)
	for i in count:
		var key = file.get_pascal_string()
		var val = file.get_var(true)
		if key and val: ProjectSettings.set_setting(key,val)
		print(key, "=", val," ",typeof(val))
		

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
		$pckSelect/btn_launch.disabled = true
		$pckSelect/btn_browse.disabled = true
		
		#var pack = load($pckSelect/path.text.replace("/","\\"))
#		var pack = PCKPacker.new()
#		pack.
		
		
		var pack_path = $pckSelect/path.text
		if ProjectSettings.load_resource_pack(pack_path,true):
			$pckSelect/btn_launch.disabled = true
			$pckSelect/btn_browse.disabled = true
			parse_and_load_settings("res://project.binary")
			print(ProjectSettings.get_setting("application/config/name"))
			OS.set_window_title(ProjectSettings.get_setting("application/config/name")+" - GdLauncher")
			
			InputMap.load_from_globals()
			yield(get_tree().create_timer(1),"timeout")
			get_tree().change_scene("res://GDLAUNCHER_FILES/scenes/sceneLoader.tscn")
		else:
			alert("Error loading PCK file, please try again")
			$pckSelect/btn_launch.disabled = false
			$pckSelect/btn_browse.disabled = false
	else:
		alert("Cannot find file, make sure the path is valid")


func _on_btn_help_pressed():
	$pckSelect/btn_help/AcceptDialog.popup()
