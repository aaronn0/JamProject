extends RigidBody3D

@onready var radar_beep := $beep

func _ready() -> void:
	radar_beep.scale = Vector3(0, 1, 0)

func beep():
	radar_beep.visible = true
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(radar_beep, "scale", Vector3(3, 1, 3), 1)
	await get_tree().create_timer(2).timeout
	radar_beep.visible = false
	radar_beep.scale = Vector3(0, 1, 0)
