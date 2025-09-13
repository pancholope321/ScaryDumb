extends Node2D


# Called when the node enters the scene tree for the first time.
@export var gun_damage=20
@export var gunLenght: int=100
@export var bullet:PackedScene
@export var bulletVelocity:float=500
@export var min_cooldown=0.5
var able_to_shoot=true
var animation_shooting="shoot"
var first_gun_setted=false
const reloadSpeed=0.75
var currentAmmo=0
var magazineSize=0
var totalAmmo=0
var currentGunIndex=0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	var realrotation=abs(fmod(rotation,2*PI))
	if realrotation>PI/2 and realrotation<3*PI/2:
		get_node("Gun").flip_v=true
	else:
		get_node("Gun").flip_v=false

# add an raytracing ray that checks if the gun actually hitted the enemy
func shoot():
	if able_to_shoot:
		able_to_shoot=false
		if totalAmmo==INF:
			currentAmmo+=1
		if currentAmmo>0:
			currentAmmo-=1
			var newBullet=bullet.instantiate()
			newBullet.global_position=get_node("Gun").global_position
			get_tree().root.call_deferred("add_child",newBullet)
			newBullet.call_deferred("set_Properties",gun_damage,bulletVelocity*Vector2(cos(global_rotation),sin(global_rotation)),gunLenght,"Enemy")
			var timer=get_node("gun_cooldown")
			timer.wait_time=min_cooldown
			timer.start()
			get_node("AnimationPlayer").current_animation=animation_shooting
			get_node("AnimationPlayer").play()
		elif totalAmmo>0:
			if totalAmmo-magazineSize>=0:
				totalAmmo-=magazineSize
				currentAmmo=magazineSize
			else:
				totalAmmo=0
				currentAmmo=totalAmmo
			var timer=get_node("gun_cooldown")
			timer.wait_time=reloadSpeed
			timer.start()
			get_node("AnimationPlayer").current_animation="reload"
			get_node("AnimationPlayer").play()
		set_gun_ammo()
			
	
func reload():
	if able_to_shoot:
		able_to_shoot=false
		if totalAmmo!=null:
			if totalAmmo>0:
				if currentAmmo<magazineSize and totalAmmo>0:
					if totalAmmo-magazineSize+currentAmmo>=0:
						totalAmmo-=magazineSize-currentAmmo
						currentAmmo=magazineSize
					else:
						totalAmmo=0
						currentAmmo=totalAmmo
					var timer=get_node("gun_cooldown")
					timer.wait_time=reloadSpeed
					timer.start()
					get_node("AnimationPlayer").current_animation="reload"
					get_node("AnimationPlayer").play()
					set_gun_ammo()
				else:
					_on_gun_cooldown_timeout()
			else:
				_on_gun_cooldown_timeout()
		else:
			_on_gun_cooldown_timeout()
		pass



func _on_gun_cooldown_timeout() -> void:
	able_to_shoot=true # Replace with function body.
	

func set_gun_properties(texture_set:String,
gun_damage_set:int,gun_lenght_set:int,bullet_scene:String,
bullet_velocity:float,min_cooldown_set:float,animation_shooting_set:String, ammo, magazine, ammoDisp, gunIndex):
	if first_gun_setted:
		get_parent().saveAmmoState(currentAmmo,magazineSize,totalAmmo,currentGunIndex)
		if currentGunIndex==gunIndex:
			return
	currentAmmo=ammo
	#print(currentAmmo)
	magazineSize=magazine
	totalAmmo=ammoDisp
	currentGunIndex=gunIndex
	get_node("Gun").texture=load(texture_set)
	gun_damage=gun_damage_set
	gunLenght=gun_lenght_set
	bullet=load(bullet_scene)
	bulletVelocity=bullet_velocity
	min_cooldown=min_cooldown_set
	animation_shooting=animation_shooting_set
	first_gun_setted=true
	get_parent().get_parent().get_node("UI/currentGun/TextureRect").texture=load(texture_set)
	set_gun_ammo()
	pass


func set_gun_ammo():
	var bulletInfoSetter=get_parent().get_parent().get_node("UI/characterInfo/bullets/bullet Count")
	bulletInfoSetter.text=str(currentAmmo)+"/"+str(magazineSize)+ "\n" + str(totalAmmo)
	
	
	
