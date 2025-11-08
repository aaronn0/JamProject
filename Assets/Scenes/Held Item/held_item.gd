extends RigidBody3D

@onready var img = $image

@export var texture : Image

var player

func _ready() -> void:
	img.material_override = StandardMaterial3D.new()
	img.material_override.albedo_texture = ImageTexture.create_from_image(texture)
	img.material_override.transparency = 1
	
	linear_damp = .5

func _physics_process(delta: float) -> void:
	player = get_parent().get_parent().find_child("player")
	if player != null:
		img.look_at(player.neck.global_position)
		img.rotate_object_local(Vector3(-1, 0, 0), PI/2)
