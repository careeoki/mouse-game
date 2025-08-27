extends Node2D

var number_particle = preload("res://particles/curds_number.tscn")
signal complete

func collect():
	get_tree().current_scene.add_cheese_curd()
	var number_particle_instance = number_particle.instantiate()
	add_child(number_particle_instance)
	await number_particle_instance.child_exiting_tree
	emit_signal("complete")
