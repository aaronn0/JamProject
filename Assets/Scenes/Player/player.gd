extends CharacterBody3D

signal reparent

const SPEED = 200

@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var ray := $Neck/Camera3D/RayCast3D
@onready var collider := $CollisionShape3D
@onready var itemPos := $Neck/Camera3D/itemPos
@onready var gui := $CanvasLayer/playerUi

var sens = 0.005
var sitting = false
var tween : Tween
var item : CollisionObject3D
var health = 3

func _ready() -> void:
	tween = create_tween()
	axis_lock_angular_y = true

func _input(event: InputEvent) -> void:
	if !sitting:
		item = null
		if event is InputEventMouseButton:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		elif event.is_action_pressed("Pause"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			if event is InputEventMouseMotion:
				neck.rotate_y(-event.relative.x * sens)
				camera.rotate_x(-event.relative.y * sens)
				camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))
		
		if event.is_action_pressed("Interact") && ray.is_colliding():
			item = ray.get_collider()
			match item.name:
				"seat":
					if tween.is_running():
						tween.kill()
					tween = create_tween()
					collider.disabled = true
					sitting = true
					tween.tween_property(self, "global_position", item.global_position + Vector3(0, 0.4, 0), 0.2)
					await get_tree().create_timer(0.2).timeout
					reparent.emit()
					item.sat()
	else:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * sens)
			camera.rotate_x(-event.relative.y * sens)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(30))
			neck.rotation.y = clamp(neck.rotation.y, deg_to_rad(-30), deg_to_rad(30))
		if event.is_action_pressed("Interact"):
			sitting = false
			item.sat()
			reparent.emit()
	
func _physics_process(delta: float) -> void:
	if !sitting:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
		var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED * delta
			velocity.z = direction.z * SPEED * delta
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		move_and_slide()

func add_health(hp : int):
	health += hp
	gui.updateHealth(health)
	print(health)

func updateText(nums : Array, reqs : Array[int], finished : bool):
	if finished:
		gui.updateText("You've collected everything you need. Follow the arrow back home.")
	else:
		var indexes = ["Trash", "Treasure", "Cutlery"]
		var string = ""
		for i in range(len(reqs)):
			if reqs[i] > 0:
				string += indexes[i] + " left to collect: " + str(nums[i]) + "/" + str(reqs[i]) + "\n"
		gui.updateText(string)
