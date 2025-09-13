extends CharacterBody2D


const SPEED = 100.0
@export var bloodSplatter:PackedScene
var gunsAvailables=[["res://Sprites/Guns/knife.png",10,2,"res://Projectiles/slice.tscn",30,0.5,"slice"]]
# cambiar los keycodes al cargar el armamento del personaje, la ammo disp
# y las guns avaiables con el archivo de config guardado, idealmente agregar las
# keycodes ordenadamente, es decir 1, 2, 3 conforme se desbloquean las diferentes armas
# 
var keycodes=[KEY_1,KEY_2,KEY_3,KEY_4,KEY_5,KEY_6]
var ammoDisp=[[1,1,INF],[12,12,120],[30,30,300],[25,25,250],[10,10,50],[4,4,24]]
var currentHealth=100
var totalHealth=100
var gold=0
const nameOfGuns=["knife","pistol","smg","rifle","sniper","granadeLauncher"]
var currentFolder=""
#@export var gun_damage=20
#@export var gunLenght: int=100
#@export var bullet:PackedScene
#@export var bulletVelocity:float=500
#@export var min_cooldown=0.5
# el arma tiene la siguiente descripcion
#texture_set,gun_damage_set,gun_lenght_set,
#bullet_scene,bullet_velocity,min_cooldown_set,animation_shooting_set
func _ready():
	#var currentFolderSet=FileAccess.open("user://current_file.txt",FileAccess.READ)
	#currentFolder=currentFolderSet.get_as_text()
	#var config = ConfigFile.new()
	#var err = config.load("user://saves/"+currentFolder+"/default.cfg")
	#if err != OK:
		#get_node("gun").callv("set_gun_properties", gunsAvailables[0]+ammoDisp[0]+[0])
		#changeCurrentHealth()
	#else:
		#gunsAvailables=[]
		#var listOfIndexes=[]
		#var index=0
		#for gun in nameOfGuns:
			#
			#var countOfNulls=0
			#if config.get_value(gun,"buy")==0:
				#gunsAvailables.append(config.get_value(gun,"values"))
			#else:
				#listOfIndexes.append(index)
				#countOfNulls+=1
			#index+=1
			#for i in range(countOfNulls):
				#keycodes.pop_back()
		#listOfIndexes.reverse()
		#for i in listOfIndexes:
			#ammoDisp.remove_at(i)
		
		#gunsAvailables=[
			#["res://Sprites/Guns/knife.png",10,2,
			#"res://Projectiles/slice.tscn",30,0.5,"slice"],
			#["res://Sprites/Guns/pistol.png",20,100,
			#"res://Projectiles/bullet.tscn",500,0.5,"shoot"],
			#["res://Sprites/Guns/submachinegun.png",10,100,
			#"res://Projectiles/bullet.tscn",500,0.2,"shoot"],
			#["res://Sprites/Guns/rifle.png",20,180,
			#"res://Projectiles/bullet.tscn",500,0.2,"shoot"],
			#["res://Sprites/Guns/sniper.png",100,300,
			#"res://Projectiles/bullet.tscn",500,1.0,"shoot"],
			#["res://Sprites/Guns/granadelaucher.png",100,180,
			#"res://Projectiles/bullet.tscn",500,1.0,"shoot"]
			#]
		#print(gunsAvailables)
		#get_node("gun").callv("set_gun_properties", gunsAvailables[0]+ammoDisp[0]+[0])
		#changeCurrentHealth()
	pass


func _physics_process(_delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionx := Input.get_axis("ui_left", "ui_right")
	var directiony := Input.get_axis("ui_up", "ui_down")
	if directionx:
		velocity.x = directionx
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if directiony:
		velocity.y = directiony
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	velocity=SPEED*(velocity.normalized())
	move_and_slide()
	if Input.is_action_pressed("ui_shoot"):
		get_node("gun").shoot()
	if Input.is_action_pressed("ui_reload"):
		get_node("gun").reload()
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_shoot"):
		#get_node("gun").shoot()
		#pass

# health and remove health
func take_damage(gun_damage,direction):
	currentHealth-=gun_damage
	#get_node("damage").play(0.0)
	var particlesInstance=bloodSplatter.instantiate()
	add_child(particlesInstance)
	particlesInstance.emitting=true
	particlesInstance.rotation=direction+PI
	await get_tree().create_timer(particlesInstance.lifetime).timeout
	particlesInstance.queue_free()
	#changeCurrentHealth()
	#if currentHealth<=0:
		#get_parent().get_node("levelHandler").playerDeath()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode in keycodes:
			var arguments=gunsAvailables[event.keycode-49]
			arguments+=ammoDisp[event.keycode-49]+[event.keycode-49]
			#print(arguments)
			get_node("gun").callv("set_gun_properties", arguments)

func saveAmmoState(currentAmmo,magazineSize,totalAmmo,currentGunIndex):
	ammoDisp[currentGunIndex]=[currentAmmo,magazineSize,totalAmmo]
	pass

func changeCurrentHealth():
	get_parent().get_node("UI/characterInfo/health/Label").text=str(currentHealth)+"/"+str(totalHealth)
	get_parent().get_node("UI/characterInfo/health/Health").value=int((100.0*(1.0*currentHealth/totalHealth)))
	
func add_gold(quantity):
	gold+=quantity
