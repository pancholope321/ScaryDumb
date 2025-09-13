extends Node

# Called when the node enters the scene tree for the first time.
var currentFolder=""
var totalEnemies=1
var tween
func _ready() -> void:
	totalEnemies=get_tree().get_nodes_in_group("Enemy").size()
	get_parent().get_node("UI/enemyCount").text=str(totalEnemies)
	var currentFolderSet=FileAccess.open("user://current_file.txt",FileAccess.READ)
	currentFolder=currentFolderSet.get_as_text()
	tween = get_tree().create_tween()
	tween.tween_property(get_parent().get_node("night"), "energy", 0, get_node("levelTimer").wait_time)
	tween.set_parallel()
	tween.tween_property(get_parent().get_node("UI/ProgressBar"), "value", 100,get_node("levelTimer").wait_time)
	#tween.play()
func _on_level_timer_timeout() -> void:
	print("timer Stopped")
	var config = ConfigFile.new()
	config.load("user://saves/"+currentFolder+"/default.cfg")
	var goldSaved = config.get_value("gold", "quantity")
	goldSaved+=get_parent().get_node("Player").gold
	config.set_value("gold", "quantity",goldSaved)
	config.save("user://saves/"+currentFolder+"/default.cfg")
	var file=FileAccess.open("user://saves/"+currentFolder+"/nextGame.txt",FileAccess.READ)
	var currentScene=file.get_as_text()
	file.close()
	file=FileAccess.open("user://saves/"+currentFolder+"/nextGame.txt",FileAccess.WRITE)
	file.store_string(str(int(currentScene)+1))
	file.close()
	get_tree().change_scene_to_file("res://Scenes/upgrade_menu.tscn")
	
	
	# call to save the gold and the
	pass # Replace with function body.

func removeEnemies():
	totalEnemies-=1
	get_parent().get_node("UI/enemyCount").text=str(totalEnemies)
	if totalEnemies==0:
		get_node("levelTimer").wait_time=10
		get_node("levelTimer").start()
		tween.kill()
		tween = get_tree().create_tween()
		tween.tween_property(get_parent().get_node("night"), "energy", 0, get_node("levelTimer").wait_time)
		tween.set_parallel()
		tween.tween_property(get_parent().get_node("UI/ProgressBar"), "value", 100,get_node("levelTimer").wait_time)
		
func playerDeath():
	get_node("levelTimer").stop()
	var dir = DirAccess.open("user://saves/"+currentFolder)
	for file in dir.get_files():
		dir.remove(file)
	DirAccess.remove_absolute("user://saves/"+currentFolder)
	get_tree().change_scene_to_file("res://Scenes/deathScene.tscn")
