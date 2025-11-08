extends "res://Assets/Scenes/Item/item.gd"

var time : float
var targetPos : Vector3
var initPos : Vector3
var speed = 300

func _ready() -> void:
	var held_item := $heldItem
	radar_beep.material_override =  StandardMaterial3D.new()
	radar_beep.material_override.albedo_color = Color(0, 0, 0, 1)
	radar_beep.visible = false
	
	
	linear_damp = 0.3
	
	tween = create_tween()
	
	var package = PackedScene.new()
	package.pack(held_item)
	identity = package
	self.remove_child(held_item)
	
	time = randf_range(14, 20)
	initPos = global_position
	targetPos = initPos + Vector3(randi_range(-7, 7), 0, randi_range(-7, 7))

func _process(delta: float) -> void:
	time -= delta
	if time < 0:
		time = randf_range(14, 20)
		targetPos = initPos + Vector3(randi_range(-7, 7), 0, randi_range(-7, 7))
		print("repositioned, " + str(targetPos))
	
	if global_position != targetPos && !sucking:
		apply_force(global_position.direction_to(targetPos).normalized() * delta * speed)
	
	if sucking:
		linear_damp = 8
