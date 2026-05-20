extends Line2D

@onready var vara = get_parent()
@onready var isca = get_parent().get_node("Bait")

func _process(delta):
	clear_points()
	add_point(to_local(vara.global_position))
	add_point(to_local(isca.global_position))
