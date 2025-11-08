extends Node3D

@onready var scanner := $SubViewport/Scanner
@onready var scanbox := $SubViewport/Scanner/ShapeCast3D
@onready var ambient := $ambientHum
@onready var beeper := $soundBeep

@onready var hum = preload("res://Assets/Sounds/radar/sfx_radar_hum_v01.wav")
@onready var beep = preload("res://Assets/Sounds/radar/sfx_radar_bleep_v01.wav")

var speed = 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ambient.stream = hum
	ambient.play()
	beeper.stream = beep

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	scanner.rotation.y -= delta * speed
	if scanbox.is_colliding():
		for i in range(scanbox.get_collision_count()):
			var collided = scanbox.get_collider(i)
			if collided != null && !collided.sucking && !collided.beeping:
				beeper.play(0.5)
				collided.beep()
