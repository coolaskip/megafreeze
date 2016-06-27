extends Area2D
var frozen = false
var meteor = preload("res://meteor.tscn")

func _ready():
	pass

func explode():
	var level = get_node("/root/level").level
	var i=0
	while (i < 2*PI):
		var m = meteor.instance()
		get_node("..").add_child(m)
		m.set_global_pos(get_pos())
		m.get_node("meteor").direction = Vector2(cos(i), sin(i))*5*level
		m.get_node("meteor").set_process(true)
		i += PI/level

func freeze():
	if (frozen):
		return
	frozen = true
	get_node("sprite").set_modulate(Color(0, 0, 10, 0))
	# Add points
	get_node("/root/game_state").points += 1000
	get_node("sfx").play("explosion")
	explode()

func is_enemy():
	return not frozen

func _on_visibility_notifier_exit_screen():
	queue_free()
