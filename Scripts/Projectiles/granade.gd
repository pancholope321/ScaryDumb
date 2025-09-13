extends CharacterBody2D

var damage=20
# Called when the node enters the scene tree for the first time.
var affectingGroup="Player"
var savedVelocitylen=0
@export var bullet:PackedScene
func set_Properties(damageSet,velocitySet,_gunLenght=100,_affectingGroup="Player"):
	affectingGroup=_affectingGroup
	velocity=velocitySet
	global_rotation=velocity.angle()
	damage=damageSet
	savedVelocitylen=velocitySet.length()
	get_node("Timer").wait_time=_gunLenght/velocitySet.length()
	get_node("Timer").start()
	
	
	pass
	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body!=null:
		if body.is_in_group(affectingGroup): # Replace with function body.
			_on_timer_timeout()
		if body.is_in_group("Background"):
			_on_timer_timeout()

func _on_timer_timeout() -> void:
	get_node("CollisionShape2D").disabled=true
	velocity=Vector2(0,0)
	for i in range(10):
		var newrotation=Vector2(1,0).rotated((i/10.0)*2.0*PI)
		print(newrotation)
		print(savedVelocitylen)
		var newBullet=bullet.instantiate()
		get_parent().call_deferred("add_child",newBullet)
		newBullet.global_position=self.global_position
		newBullet.call_deferred("set_Properties",damage,newrotation*savedVelocitylen,50,"Player")
	
	self.queue_free() # Replace with function body.
