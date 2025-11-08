extends RigidBody3D

var velocity := Vector3(0, 0, 0)
var speed := 50000
var a_speed := 50000
var forward : int
var dir : int
var bomb_collider : ShapeCast3D

signal bomb

@onready var seat := $seat
@onready var above_collider := $aboveCollider
@onready var vacuum := $sucker
@onready var endNeck := $EndNeck

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_damp = 0.3
	angular_damp = 0.3
	bomb_collider = above_collider.find_child("ShapeCast3D")

func _input(event: InputEvent) -> void:
	if seat.sitting:
		if event.is_action_pressed("Suck"):
			set_collision_layer_value(5, false)
			set_collision_mask_value(5, false)
			vacuum.sucking = true
		elif event.is_action_released("Suck"):
			set_collision_layer_value(5, true)
			set_collision_mask_value(5, true)
			vacuum.sucking = false

func _physics_process(delta: float) -> void:
	if seat.sitting:
		var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
		var torque = Vector3(0, input_dir.x, 0).normalized()
		apply_torque(-torque * a_speed * delta)
		var direction = (transform.basis * Vector3(0, 0, input_dir.y)).normalized()
		apply_force(direction * speed * delta)
	if bomb_collider.is_colliding():
		for i in range(bomb_collider.get_collision_count()):
			var collided = bomb_collider.get_collider(i)
			if collided != null:
				if collided.name.begins_with("bomb"):
					collided.drop_item(Vector3(0, 0, 0))
					_on_sucker_bomb()
				else:
					bomb_collider.add_exception(collided)
	endNeck.look_at(get_parent().endPos.global_position)


func _on_sucker_bomb() -> void:
	bomb.emit()
