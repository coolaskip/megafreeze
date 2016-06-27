extends Area2D

var SPEED = 600
var hit = false

func init_raycast(rc):
	get_node(rc).add_exception(self)
	get_node(rc).set_cast_to(Vector2(0, -SPEED/6))

func check_raycast(rc):
	var raycast = get_node(rc)
	var first_collider = raycast.get_collider()
	if raycast.is_colliding():
		_on_Area2D_area_enter(first_collider)
	return null

func check_collision():
	var collision_l = check_raycast("raycast_l")
	var collision_r = check_raycast("raycast_r")

func _ready():
	set_process(true)
	init_raycast("raycast_l")
	init_raycast("raycast_r")
	
func _process(delta):
	var collision = check_collision()
	if collision != null:
		set_global_pos(collision)
	else:
		translate(Vector2(0, -delta*SPEED))

func _hit_something():
	if (hit):
		return
	hit = true
	set_process(false)
	queue_free()

func _on_VisibilityNotifier2D_exit_screen():
	queue_free()

func _on_Area2D_area_enter(area):
	# Froze asteroid
	if (area.has_method("freeze") and area.has_method("is_enemy") and area.is_enemy()):
		area.freeze()
		_hit_something()
