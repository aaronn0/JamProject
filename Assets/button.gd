extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icon = ImageTexture.create_from_image(preload("res://Assets/Sprites and Models/button_default.png"))

func _pressed() -> void:
	get_tree().change_scene_to_file("res://level_one.tscn")
