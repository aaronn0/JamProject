extends "res://Assets/Scenes/Item/item.gd"

@onready var radius := $radius
@onready var audio = $AudioStreamPlayer3D

var time = 0

func _ready() -> void:
	radar_beep.material_override =  StandardMaterial3D.new()
	radar_beep.material_override.albedo_color = Color(0, 0, 0, 1)
	radar_beep.visible = false
	
	linear_damp = 1
	
	tween = create_tween()
	

func drop_item(pos : Vector3):
	visible = false
	collider.disabled = true
	SoundManager.play_sound(sounds.pick_random())
	queue_free()

func _process(delta: float) -> void:
	var item = null
	if radius.is_colliding():
		for i in range(radius.get_collision_count()):
			var collided = radius.get_collider(i)
			if collided.name == "submarine":
				item = collided
				break
			else:
				radius.add_exception(collided)
	
	if item != null && time <= 0:
		audio.play(0.5)
		time = ((global_position * Vector3(1, 0, 1)).distance_to(item.global_position * Vector3(1, 0, 1))- 5)/10
	
	if time > 0:
		time -= delta
