extends Button





func _on_pressed() -> void:
	get_parent().visible=false
	get_parent().get_parent().get_node("firstMenu").visible=true # Replace with function body.
