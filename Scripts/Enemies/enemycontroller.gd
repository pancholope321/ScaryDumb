extends CharacterBody2D
@export var life=100
@export var idling_distance=100
@export var SPEED= 50
@export var LOOKINGSPEED= 20
@export var WALKINGSPEED= 10
@export var looking_distance=100
@export var goldDropped:int=10
@export var bloodSplatter:PackedScene
@export var goldCoin:PackedScene
enum {
	IDLING,
	LOOKING,
	FOLLOWING,
	SHOOTING
}
var player=null
var state=IDLING
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("CheckPlayer").shape.points=[Vector2(0,0),Vector2(looking_distance/2.0,looking_distance),Vector2(-looking_distance/2.0,looking_distance)]
	pass

func _physics_process(_delta: float) -> void:
	if player!=null:
		match state:
			IDLING:
				move_randomly(WALKINGSPEED)
				if global_position.distance_to(player.global_position)<idling_distance:
					state=LOOKING
			LOOKING:
				move_randomly(LOOKINGSPEED)
				if global_position.distance_to(player.global_position)>=idling_distance:
					state=IDLING
				if looking_for_player():
					state=FOLLOWING
				pass
			FOLLOWING:
				move_to_player(SPEED)
				if global_position.distance_to(player.global_position)>=idling_distance:
					state=IDLING
				if able_to_shoot():
					state=SHOOTING
				pass
			SHOOTING:
				get_node("CheckPlayer").look_at(player.global_position)
				get_node("gun").state=SHOOTING
				if !able_to_shoot():
					state=FOLLOWING
	else:
		for node in get_tree().get_nodes_in_group("Player"):
			player=node
			
# Called every frame. 'delta' is the elapsed time since the previous frame.



func move_randomly(speed):
	velocity+=Vector2(randf()-0.5,randf()-0.5)*speed/10.0
	velocity=velocity.normalized()*speed
	move_and_slide()
	get_node("gun").state=state
	get_node("gun").rotation=velocity.angle()*0.1+get_node("gun").rotation*0.9
	get_node("CheckPlayer").rotation=get_node("gun").rotation-PI/2.0

func move_to_player(speed):
	velocity=Vector2(player.global_position-self.global_position).normalized()*speed
	get_node("gun").state=state
	get_node("gun").rotation=velocity.angle()
	get_node("CheckPlayer").rotation=velocity.angle()-PI/2.0
	move_and_slide()

func looking_for_player():
	var collider=get_node("CheckPlayer")
	if collider.is_colliding():
		var largo=collider.get_collision_count()
		for index in range(largo):
			var hitted=collider.get_collider(index)
			if hitted!=null:
				if hitted.is_in_group("Player"):
					return true
		return false

func able_to_shoot():
	var hitted=get_node("gun/RayCast2D").get_collider()
	if hitted!=null:
		if hitted.is_in_group("Player"):
			return true
	return false


func take_damage(value, direction):
	
	if state!=SHOOTING:
		state=FOLLOWING
	life-=value
	if life<=0:
		var coin=goldCoin.instantiate()
		coin.quantity=goldDropped
		get_parent().call_deferred("add_child",coin)
		coin.global_position=self.global_position
		get_parent().get_node("deathSound").play(0.0)
		get_tree().call_group("Level Handler","removeEnemies")
		self.queue_free()
	get_node("damage").play(0.0)
	var particlesInstance=bloodSplatter.instantiate()
	add_child(particlesInstance)
	particlesInstance.emitting=true
	particlesInstance.rotation=direction+PI
	await get_tree().create_timer(particlesInstance.lifetime).timeout
	particlesInstance.queue_free()
	
	# animate the direction in witch the damage was taken
