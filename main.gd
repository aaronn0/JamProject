extends Node

@onready var camPlayer = $player/Neck/Camera3D
@onready var camWorld = $Camera3D
@onready var ambience = preload("res://Assets/Sounds/amb_underwater_bed_v02.wav")
@onready var player = $player
@onready var submarine = $submarine


@export var reqs : Array[int]

var sitting = false
var numTrash = 0
var numTreasure = 0
var numCutlery = 0
var health = 3
var items : Array
var endCollider
var endPos
var time = 240

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	endPos = $Map/endPoint
	endCollider = endPos.find_child("Area3D")
	camPlayer.current = true
	SoundManager.play_ambient_sound(ambience)
	player.updateText([numTrash, numTreasure, numCutlery], reqs, false)
	endCollider.monitoring = false
	endCollider.body_entered.connect(hit_end_pos)

func _process(delta: float) -> void:
	time -= delta
	player.gui.updateTime(str(int(time / 60)) + ":" + str(round(fmod(time, 60))))
	if health < 0 || time <= 0:
		get_tree().change_scene_to_file("res://death.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		camPlayer.current = true

func _on_player_reparent() -> void:
	if !sitting:
		var target = $submarine
		var source = $player
		self.remove_child(source)
		target.add_child(source)
		source.owner = target
		source.neck.rotation.y = target.global_rotation.y
		source.camera.rotation.x = target.global_rotation.x
	else:
		var target = $submarine
		var source = $submarine/player
		target.remove_child(source)
		self.add_child(source)
		source.owner = self
		source.global_position = target.seat.global_position + Vector3(0, 1, 0)
		source.neck.rotation.y = target.global_rotation.y
		source.camera.rotation.x = target.global_rotation.x
		source.collider.disabled = false
	sitting = !sitting


func _on_submarine_bomb() -> void:
	player.add_health(-1)
	_CameraShake3D._init_camera_shake(player.camera)

func add_item(item : CollisionObject3D):
	items.append(str(item.name))
	numTrash = len(items.filter(func(k): return k[0] == "t"))
	numTreasure = len(items.filter(func(k): return k.begins_with("re")))
	numCutlery = len(items.filter(func(k): return k.begins_with("rec")))
	var finished = numTrash >= reqs[0] && numTrash >= reqs[1] && numTreasure >= reqs[2]
	player.updateText([numTrash, numTreasure, numCutlery], reqs, finished)
	if finished:
		end_pos_shown()

func end_pos_shown():
	endPos.visible = true
	endCollider.monitoring = true
	submarine.endNeck.visible = true

func hit_end_pos(body : CollisionObject3D):
	print("won")
	if body.name == "submarine":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("res://main_menu.tscn")
