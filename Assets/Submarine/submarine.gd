extends RigidBody3D

var velocity := Vector3(0, 0, 0)
var speed := 75
var a_speed := 45
var forward : int
var dir : int

@onready var seat := $seat

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_damp = 0.4
	angular_damp = 0.4

func _physics_process(delta: float) -> void:
	if seat.sitting:
		var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
		if input_dir.y > 0:
			input_dir.y = 0
		
		var torque = Vector3(0, input_dir.x, 0).normalized()
		apply_torque(-torque * a_speed)
		var direction = (transform.basis * Vector3(0, 0, input_dir.y)).normalized()
		apply_force(direction * speed)
