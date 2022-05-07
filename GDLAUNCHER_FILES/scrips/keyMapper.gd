extends Node

#TODO: Add keybind saving



func _on_ConfirmationDialog_confirmed():
	get_tree().change_scene("res://GDLAUNCHER_FILES/scenes/sceneLoader.tscn")

func _on_btn_confirm_pressed():
	$btn_confirm/ConfirmationDialog.popup()

func _on_btn_back_pressed():
	get_tree().change_scene("res://GDLAUNCHER_FILES/scenes/GdLauncherMain.tscn")
