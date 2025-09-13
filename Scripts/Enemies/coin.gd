extends Area2D


var quantity=0
var isActive=true
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and isActive:
		isActive=false
		get_node("coinSprite").visible=false
		get_node("Collect").set_deferred("disabled",true)
		body.gold+= quantity# Replace with function body.
		get_node("animation").play("get_coin")
		 # Replace with function body.
		
