
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"
export(Vector2) var direction = Vector2(0, 0)
var frozen = false

func _ready():
	var p_dir = direction * Vector2(-1, 1)
	var angle = rad2deg(p_dir.angle_to(Vector2(0, -1)))
	#var angle = direction.angle()
	get_node("particles").set_param(Particles2D.PARAM_DIRECTION, angle)
	#set_process(true)

func _process(delta):
	translate(direction*delta)

func freeze():
	if (frozen):
		return
	frozen = true
	get_node("sprite").set_modulate(Color(0, 0, 10, 0))
	get_node("particles").set_emitting(false)
	get_node("sfx").play("explosion_small")
	get_node("explosion").set_emitting(true)
	# Accumulate points
	get_node("/root/game_state").points += 10

func is_enemy():
	return not frozen

func _on_visibility_enter_screen():
	# can't use that as only a part of a wave will be active
	# and will come 5 by 5 instead of a continuous flow
	#set_process(true)
	pass


func _on_visibility_exit_screen():
	queue_free()
