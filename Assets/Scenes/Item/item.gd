extends RigidBody3D

@onready var radar_beep = $beep
@onready var collider = $CollisionShape3D

@export var sounds : Array[AudioStream]

var tween
var sucking = false
var identity
var beeping = false

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

func beep():
	if !sucking:
		beeping = true
		fade_in()
		var timer = get_tree().create_timer(2)
		await timer.timeout
		timer.is_queued_for_deletion()
		beeping = false
		fade_away()

func fade_in():
	if !radar_beep.visible:
		radar_beep.visible = true
		if tween.is_running():
			tween.kill()
		tween = create_tween()
		tween.tween_property(radar_beep.material_override, "albedo_color", Color(0, 1, 0, 1), 0.2)
		await get_tree().create_timer(0.2).timeout
		tween.is_queued_for_deletion()

func fade_away():
	if radar_beep.visible:
		if tween.is_running():
			tween.kill()
		tween = create_tween()
		tween.tween_property(radar_beep.material_override, "albedo_color", Color(0, 0, 0, 1), 1.3)
		tween.is_queued_for_deletion()
		await get_tree().create_timer(1.3).timeout
		radar_beep.visible = false

func drop_item(pos : Vector3):
	var temp = identity.instantiate()
	var parent = self.get_parent().get_parent()
	parent.find_child("submarine").add_child(temp)
	temp.global_position = pos
	visible = false
	collider.disabled = true
	SoundManager.play_sound(sounds.pick_random())
	queue_free()
