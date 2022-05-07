#UtilsGD
#Make Godot experience easier!
#You can find bunch of small functions that turns multiple lines of code into just one function.
#Feel free to use and modify for your pruposes
#Author: Wolfyxon

extends Node
signal new_output
signal process_ended

var errors = {
	0:"OK",
	1:"FAILED",
	2:"ERR_UNAVAILABLE",
	3:"ERR_UNCONFIGURED",
	4:"ERR_UNAUTHORIZED",
	5:"ERR_PARAMETER_RANGE_ERROR",
	6:"ERR_OUT_OF_MEMORY",
	7:"ERR_FILE_NOT_FOUND",
	8:"ERR_FILE_BAD_DRIVE",
	9:"ERR_FILE_BAD_PATH",
	10:"ERR_FILE_NO_PERMISSION",
	11:"ERR_FILE_ALREADY_IN_USE",
	12:"ERR_FILE_CANT_OPEN",
	13:"ERR_FILE_CANT_WRITE",
	14:"ERR_FILE_CANT_READ",
	15:"ERR_FILE_UNRECOGNIZED",
	16:"ERR_FILE_CORRUPT",
	17:"ERR_FILE_MISSING_DEPENDENCIES",
	18:"ERR_FILE_EOF",
	19:"ERR_CANT_OPEN",
	20:"ERR_CANT_CREATE",
	21:"ERR_QUERY_FAILED",
	22:"ERR_ALREADY_IN_USE",
	23:"ERR_LOCKED",
	24:"ERR_TIMEOUT",
	25:"ERR_CANT_CONNECT",
	26:"ERR_CANT_RESOLVE",
	27:"ERR_CONNECTION_ERROR",
	28:"ERR_CANT_ACQUIRE_RESOURCE",
	29:"ERR_CANT_FORK",
	30:"ERR_INVALID_DATA",
	31:"ERR_INVALID_PARAMETER",
	32:"ERR_ALREADY_EXISTS",
	33:"ERR_DOES_NOT_EXIST",
	34:"ERR_DATABASE_CANT_READ",
	35:"ERR_DATABASE_CANT_WRITE",
	36:"ERR_COMPILATION_FAILED",
	37:"ERR_METHOD_NOT_FOUND",
	38:"ERR_LINK_FAILED",
	39:"ERR_SCRIPT_FAILED",
	40:"ERR_CYCLIC_LINK",
	41:"ERR_INVALID_DECLARATION",
	42:"ERR_DUPLICATE_SYMBOL",
	43:"ERR_PARSE_ERROR",
	44:"ERR_BUSY",
	45:"ERR_SKIP",
	46:"ERR_HELP",
	47:"ERR_BUG",
	48:"ERR_PRINTER_ON_FIRE"
}

var readyPrint = true
func _ready():
	if readyPrint: print("UtilsGD is ready")
	
func _physics_process(delta):
	pass

var threads = []
var _outputs = []
var _processes = []

###########################################################
# == Basic functions ==

#TODO: finish
func execute_output(command:String,args:PoolStringArray = []): #Executes a process without freezing the game but also captures the output
	push_warning("execute_output is not recommended to use. Method is under construction")
	var id = _outputs.size()
	var thread = Thread.new()
	thread.start(self,"_exe_thread",{"command": command,"args":args,"id":id})
	return id

func clear_children(node):
	for n in node.get_children():
		n.queue_free()

func random(_min, _max): #Better random. Compare rand_range to this function
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	var rannum
	rannum = RNG.randf_range(_min, _max)
	return rannum
	
func set_parent(node,parent): #Changes parent of a node
	parent.add_child(node.duplicate())
	node.queue_free()


func get_error_name_from_code(error_code:int):
	if error_code in errors:
		return errors[error_code]
	return

#= Sounds =
func play_sound(path:String,volume:float=0,pitch:float=1,bus:String="master"):
	var a = AudioStreamPlayer.new()
	a.stream = load(path)
	a.volume_db = volume
	a.pitch_scale = pitch
	a.bus = bus
	get_tree().current_scene.add_child(a)
	a.play()
	yield(a,"finished")
	a.queue_free()
	
func play_sound_vec2(path:String,position: Vector2,volume:float=0,pitch:float=1,distance:float=2000,bus:String="master"):
	var a = AudioStreamPlayer2D.new()
	a.global_position = position
	a.max_distance = distance
	a.stream = load(path)
	a.volume_db = volume
	a.pitch_scale = pitch
	a.bus = bus
	get_tree().current_scene.add_child(a)
	a.play()
	yield(a,"finished")
	a.queue_free()

func play_sound_vec3(path:String,position: Vector3,volume:float=0,pitch:float=1,distance:float=2000,bus:String="master"):
	var a = AudioStreamPlayer3D.new()
	get_tree().current_scene.add_child(a)
	a.global_transform.origin = position
	a.max_distance = distance
	a.stream = load(path)
	a.unit_db = volume
	a.pitch_scale = pitch
	a.bus = bus
	a.play()
	yield(a,"finished")
	a.queue_free()

func os_beep(): #Plays default sound of your OS
	OS.execute("^G",[],false) #Should work on most of OSes

#= Sounds =

# == Quick tweens ==
#These functions allows you to quickly animate nodes' positions and rotations without making an animation or tween.
#These functions make tweens but it's just one line of code

#Best easing styles
#Tween.TRANS_QUART - smooth accelerate and slow down
#Tween.TRANS_LINEAR - just get to the point with the same speed

# Moving:
func smooth_move_2d(node,targetPosition: Vector2,duration: float,easingStyle=Tween.TRANS_QUART): #For Node2D
	var tween = Tween.new()
	tween.interpolate_property(node,"global_position",
	node.global_position,targetPosition,
	duration,easingStyle,Tween.EASE_IN_OUT)
	
	get_tree().current_scene.add_child(tween)
	tween.start()
	return tween

func smooth_move_rect(node,targetPosition: Vector2,duration: float,easingStyle=Tween.TRANS_QUART): #For Control
	var tween = Tween.new()
	tween.interpolate_property(node,"rect_global_position",
	node.rect_global_position,targetPosition,
	duration,easingStyle,Tween.EASE_IN_OUT)
	
	get_tree().current_scene.add_child(tween)
	tween.start()
	return tween

func smooth_move_3d(node,targetPosition: Vector3,duration: float,easingStyle=Tween.TRANS_QUART): #For Spatial
	var tween = Tween.new()
	tween.interpolate_property(node,"global_transform:origin",
	node.global_transform.origin,targetPosition,
	duration,easingStyle,Tween.EASE_IN_OUT)
	
	get_tree().current_scene.add_child(tween)
	tween.start()
	return tween

#Rotating:
func smooth_rotate_2d(node,targetRotation: float,duration: float,easingStyle=Tween.TRANS_QUART): #For Node2D
	var tween = Tween.new()
	tween.interpolate_property(node,"global_rotation_degrees",
	node.global_rotation_degrees,targetRotation,
	duration,easingStyle,Tween.EASE_IN_OUT)
	
	get_tree().current_scene.add_child(tween)
	tween.start()
	return tween

func smooth_rotate_rect(node,targetRotation: float,duration: float,easingStyle=Tween.TRANS_QUART): #For Control
	var tween = Tween.new()
	tween.interpolate_property(node,"rect_rotation",
	node.rect_rotation,targetRotation,
	duration,easingStyle,Tween.EASE_IN_OUT)
	
	get_tree().current_scene.add_child(tween)
	tween.start()
	return tween

func smooth_rotate_3d(node,targetRotation: Vector3,duration: float,easingStyle=Tween.TRANS_QUART): #For Control
	var tween = Tween.new()
	tween.interpolate_property(node,"rotation_degrees",
	node.rotation_degrees,targetRotation,
	duration,easingStyle,Tween.EASE_IN_OUT)
	
	get_tree().current_scene.add_child(tween)
	tween.start()
	return tween

#################################
#THREADS, do not touch unless you know what you're doing
func _exe_thread(data):
	_outputs.append([])
	_processes.append( OS.execute(data["command"],data["args"],true,_outputs[data["id"]]) )



