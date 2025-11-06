extends RigidBody3D

@onready var collider = $CollisionShape3D

var held = false
var speed = 1000

func hold_item(point: Joint3D, parent: Node3D):
	var held = true
	print(parent.name)
	get_parent().remove_child(self)
	parent.add_child(self)
	self.owner = parent
	gravity_scale = 0
	collider.disabled = true
	
	axis_lock_linear_x = true
	axis_lock_linear_y = true
	axis_lock_linear_z = true
	self.position = Vector3(0, 0, 0)
	self.rotation = Vector3(0, 0, 0)
	
	point.node_b = self.get_path()

func drop(parent: Node):
	held = false
	get_parent().remove_child(self)
	parent.add_child(self)
	self.owner = parent
	
	axis_lock_angular_x = false
	axis_lock_angular_y = false
	axis_lock_angular_z = false
	gravity_scale = 1
	collider.disabled = false
