extends VBoxContainer

func _ready():
	set_process(true)

func _process(delta):
	var pos = get_viewport().get_mouse_pos()
	get_node("pointer").set_global_pos(pos)


func _on_game_over_visibility_changed():
	get_node("score_value").set_text(str(get_node("/root/game_state").points))
	get_node("high_value").set_text(str(get_node("/root/game_state").max_points))


func _on_freeze_more_pressed():
	get_node("/root/game_state").points = 0
	get_tree().change_scene("res://level.tscn")
