extends CanvasLayer

var isOpen = false
var threads = []

func _ready():
	$outsidePanelClose.visible = false
	print("GDLauncher panel has been added to current scene")
	$AnimationPlayer.play("first")
	
	$"Panel/debug info/appInfo/icon".texture = load(ProjectSettings.get_setting("application/config/icon"))
	$"Panel/debug info/appInfo/name".text = ProjectSettings.get_setting("application/config/name")

func _physics_process(delta):
	
	$Panel/Main/switches/ch_fullscreen.pressed = OS.window_fullscreen
	if $"Panel/debug info".visible: load_debug_info()
	
	if Input.is_key_pressed(KEY_CONTROL) and Input.is_key_pressed(KEY_BACKSLASH):
		$Label.visible = false
		if isOpen:
			close()
		else:
			open()
	if Input.is_key_pressed(KEY_ESCAPE):
		close()

func load_debug_info():
	$"Panel/debug info/text".text = "Debug info\n"+\
	"FPS: "+String(Engine.get_frames_per_second())+"\n"+\
	"Memory usage: "+String(OS.get_dynamic_memory_usage())+"\n"+\
	"Process ID: "+String(OS.get_process_id())


onready var logFile = File.new()
func get_logs():
	var path = ProjectSettings.get_setting("logging/file_logging/log_path").replace("user://",OS.get_user_data_dir()+"\\")
	var err = logFile.open(path,logFile.READ)
	if err != OK:
		getting_logs_failed()
		return ""
	var text = logFile.get_as_text()
	logFile.close()
	return text

var last_logs = ""
func _on_refreshLogs_timeout():
	if ProjectSettings.get_setting("logging/file_logging/enable_file_logging"):
		if $Panel/logs.visible: 
			if last_logs != get_logs():
				last_logs = get_logs()
				$Panel/logs/console.text = get_logs()
	else:
		getting_logs_failed()

func getting_logs_failed():
	$Panel/logs/console.text = """Unable to get logs
This game has disabled file logging, please run GDLauncher from your system terminal and view logs in console
	"""
	$timers/refreshLogs.stop()

func open():
	if not(isOpen and $AnimationPlayer.is_playing()):
		$outsidePanelClose.visible = true
		isOpen = true
		$AnimationPlayer.play("open")
	
func close():
	if isOpen and not($AnimationPlayer.is_playing()):
		$outsidePanelClose.visible = false
		isOpen = false
		$AnimationPlayer.play_backwards("open")

func _on_outsidePanelClose_pressed():
	close()



func _on_btn_eval_pressed():
	var th = Thread.new()
	th.start(self,"eval",$Panel/eval/code.text)
	threads.append(th)


func eval(code):
	$Panel/eval/error.text = "No errors detected"
	var gdscript = GDScript.new()
	gdscript.set_source_code("extends Node\n"+code)
	var err = gdscript.reload() 
	if err == OK:
		var n = Node.new()
		n.name = "TmpEvalScript"
		$evalScriptInstances.add_child(n)
		n.set_script(gdscript)
		n.call("_ready")
	else:
		$Panel/eval/error.text = UtilsGd.get_error_name_from_code(err)+" for more details, see logs"



func _on_btn_destroy_script_pressed():
	for n in $evalScriptInstances.get_children():
		n.set_script(null)
		n.queue_free()

#utility buttons

func _on_btn_appdata_pressed():
	OS.shell_open(OS.get_user_data_dir())


func _on_btn_exedir_pressed():
	OS.shell_open(OS.get_executable_path().get_base_dir())


func _on_btn_exit_pressed():
	get_tree().quit()


func _on_btn_kill_pressed():
	OS.kill(OS.get_process_id())

func _on_btn_change_scene_pressed():
	$Panel/Main/buttons/btn_change_scene/scene_selection.popup()

func _on_scene_selection_file_selected(path):
	var err = get_tree().change_scene(path)

#switches
func _on_ch_paused_toggled(button_pressed):
	get_tree().paused = button_pressed

func _on_ch_fullscreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed





