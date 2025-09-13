extends Node2D

enum {
	IDLING,
	LOOKING,
	FOLLOWING,
	SHOOTING
}
@export var gun_damage=20
var state=IDLING
@export var min_cooldown=1.0
var firstShot=true
@export var first_shot_cooldown=1.0
var able_to_shoot=false
@onready var timer=$gun_cooldown
@export var gunLenght: int=200
@export var bullet:PackedScene
@export var bulletVelocity:float=500
func _ready() -> void:
	change_raycast_leng(gunLenght)

func _physics_process(_delta: float) -> void:
	var realrotation=abs(fmod(rotation,2*PI))
	if realrotation>PI/2 and realrotation<3*PI/2:
		get_node("Gun").flip_v=true
	else:
		get_node("Gun").flip_v=false
	match state:
		IDLING:
			pass
		LOOKING:
			pass
		FOLLOWING:
			firstShot=true
			able_to_shoot=false
			pass
		SHOOTING:
			look_at(get_parent().player.global_position)
			if firstShot:
				timer.wait_time=first_shot_cooldown
				timer.start()
				firstShot=false
			if able_to_shoot:
				able_to_shoot=false
				shoot()
				timer.wait_time=min_cooldown
				timer.start()
			pass

func shoot():
	var newBullet=bullet.instantiate()
	newBullet.global_position=get_node("Gun").global_position
	get_tree().root.call_deferred("add_child",newBullet)
	newBullet.call_deferred("set_Properties",gun_damage,bulletVelocity*Vector2(cos(global_rotation),sin(global_rotation)),gunLenght)
	get_node("gunAnimation").play("shot")
func change_raycast_leng(newlen:int):
	get_node("RayCast2D").target_position=Vector2(newlen,0)

func _on_gun_cooldown_timeout() -> void:
	able_to_shoot=true
	pass # Replace with function body.
