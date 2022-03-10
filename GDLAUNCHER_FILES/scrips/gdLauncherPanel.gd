extends Node2D

var isOpen = false

func _ready():
	$outsidePanelClose.visible = false
	self.set_as_toplevel(true)
	print("GDLauncher panel has been added to current scene")
	$AnimationPlayer.play("first")

func _physics_process(delta):
	
	if Input.is_key_pressed(KEY_CONTROL) and Input.is_key_pressed(KEY_F12):
		$Label.visible = false
		if isOpen:
			close()
		else:
			open()
	if Input.is_key_pressed(KEY_ESCAPE):
		close()
		
		
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
	var gdscript = GDScript.new()
	var code = $Panel/eval/code.text
	print("= Running code =")
	print(code)
	print("= End =")
	gdscript.set_source_code("extends Node\n"+code)
	gdscript.reload()
	
	var n = Node.new()
	n.name = "TmpEvalScript"
	$evalScriptInstances.add_child(n)
	n.set_script(gdscript)
	n.call("_ready")


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

#switches
func _on_ch_paused_toggled(button_pressed):
	get_tree().paused = button_pressed


