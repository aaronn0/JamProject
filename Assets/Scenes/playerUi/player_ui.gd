extends Control

@onready var healthbar = $TextureRect
@onready var textbox := $TextEdit
@onready var timebox := $RichTextLabel

@export var states : Array[Image]

var textStates : Array[ImageTexture]

func _ready() -> void:
	for i in states:
		textStates.append(ImageTexture.create_from_image(i))
	healthbar.texture = textStates[3]

func updateHealth(hp : int):
	healthbar.texture = textStates[hp]

func updateText(text : String):
	textbox.text = text

func updateTime(text : String):
	timebox.text = "[center]" + text + "[/center]"
