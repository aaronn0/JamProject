extends Node3D

@onready var scanner = $SubViewport/Scanner
@onready var scanbox = $SubViewport/Scanner/ShapeCast3D

var speed = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	scanner.rotation.y -= delta * speed
	if scanbox.is_colliding():
		for i in range(scanbox.get_collision_count()):
			var collided = scanbox.get_collider(i)
			collided.beep()
