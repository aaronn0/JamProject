extends Node

var sitting = false

@onready var camPlayer = $player/Neck/Camera3D
@onready var camWorld = $Camera3D
@onready var ambience = preload("res://Assets/Sounds/amb_underwater_bed.wav")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camWorld.current = true
	SoundManager.play_ambient_sound(ambience)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		camPlayer.current = true
	elif event.is_action_pressed("Pause"):
		camWorld.current = true

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
		source.global_position = target.seat.global_position
		source.neck.rotation.y = target.global_rotation.y
		source.camera.rotation.x = target.global_rotation.x
	sitting = !sitting
