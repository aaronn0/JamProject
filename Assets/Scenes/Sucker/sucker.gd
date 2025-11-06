extends Node3D

@onready var vacuum := $Vacuum
@onready var sprite := $"Suck Sprite"
@onready var exit := $"Exit Checker"
@onready var chute := $Chute

var force = 4500
var sucking = false
var entered_items : Array

func _ready() -> void:
	chute.monitoring = false
	chute.body_entered.connect(chute_entered)

func suck_in(delta : float):
	if vacuum.is_colliding():
		for i in range(vacuum.get_collision_count()):
			var collided = vacuum.get_collider(i)
			if collided != null:
				collided.apply_force(vacuum.get_collision_point(i).direction_to(global_position) * force * delta)
				collided.fade_in()
				collided.sucking = true


func _process(delta: float) -> void:
	if sucking:
		if !sprite.visible:
			chute.monitoring = true
			exit.monitoring = true
			sprite.visible = true
		suck_in(delta)
		entered_items = exit.get_overlapping_bodies()
	else:
		if sprite.visible:
			on_item_exited()
			chute.monitoring = false
			exit.monitoring = false
			sprite.visible = false

func on_item_exited():
	for i in entered_items:
		i.sucking = false
		i.fade_away()
	entered_items = []

func chute_entered(body : CollisionObject3D):
	print("entered")
	body.drop_item(self.get_parent().basis * Vector3(0, 0, 2) + position)
