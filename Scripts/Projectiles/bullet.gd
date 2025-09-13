extends CharacterBody2D

var damage=20
# Called when the node enters the scene tree for the first time.
var affectingGroup="Player"
func set_Properties(damageSet,velocitySet,_gunLenght=100,_affectingGroup="Player"):
	affectingGroup=_affectingGroup
	velocity=velocitySet
	global_rotation=velocity.angle()
	damage=damageSet
	get_node("Timer").wait_time=_gunLenght/velocitySet.length()
	get_node("Timer").start()
	
	get_node("AnimationPlayer").speed_scale = 1/(_gunLenght/velocitySet.length())
	
	pass
	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body!=null:
		if body.is_in_group(affectingGroup):
			body.take_damage(damage,global_rotation) # Replace with function body.
			self.queue_free()
		if body.is_in_group("Background"):
			self.queue_free()

func _on_timer_timeout() -> void:
	self.queue_free() # Replace with function body.
