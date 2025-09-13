extends Control
var weaponsList=["knife","pistol","smg","granadeLauncher","rifle","sniper"]
@export var menu_instance:PackedScene
var currentFolder=""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var currentFolderSet=FileAccess.open("user://current_file.txt",FileAccess.READ)
	currentFolder=currentFolderSet.get_as_text()
	
	if !FileAccess.file_exists("user://saves/"+currentFolder+"/default.cfg"):
		var file=FileAccess.open("res://Player/default.cfg",FileAccess.READ)
		var newFile=FileAccess.open("user://saves/"+currentFolder+"/default.cfg",FileAccess.WRITE)
		newFile.store_string(file.get_as_text())
		newFile.close()
		file.close()
	var config = ConfigFile.new()
	var err = config.load("user://saves/"+currentFolder+"/default.cfg")
	if err != OK:
		return
	for weapons in weaponsList:
		for key in config.get_section_keys(weapons):
			if key!="values":
				var progress=config.get_value(weapons, key)
				var instance=menu_instance.instantiate()
				get_node("guns").get_node(str(weapons)).get_node("upgrades").call_deferred("add_child",instance)
				instance.set_upgrade_values(key,progress,weapons,key)
			pass
	
	
	

func _on_knife_pressed() -> void:
	get_tree().set_group("selector","visible",false)
	get_node("guns/knife").visible=true # Replace with function body.


func _on_pistol_pressed() -> void:
	get_tree().set_group("selector","visible",false)
	get_node("guns/pistol").visible=true # Replace with function body.


func _on_sub_machine_gun_pressed() -> void:
	get_tree().set_group("selector","visible",false)
	get_node("guns/smg").visible=true # Replace with function body.


func _on_granade_launcher_pressed() -> void:
	get_tree().set_group("selector","visible",false)
	get_node("guns/granadeLauncher").visible=true # Replace with function body.


func _on_rifle_pressed() -> void:
	get_tree().set_group("selector","visible",false)
	get_node("guns/rifle").visible=true # Replace with function body.


func _on_sniper_pressed() -> void:
	get_tree().set_group("selector","visible",false)
	get_node("guns/sniper").visible=true # Replace with function body.


func _on_continue_pressed() -> void:
	var file
	if !FileAccess.file_exists("user://saves/"+currentFolder+"/nextGame.txt"):
		file=FileAccess.open("user://saves/"+currentFolder+"/nextGame.txt",FileAccess.WRITE)
		file.store_string("0")
		file.close()
	file=FileAccess.open("user://saves/"+currentFolder+"/nextGame.txt",FileAccess.READ)
	var goToNewScene=file.get_as_text()
	get_tree().change_scene_to_file("res://Scenes/"+goToNewScene+".tscn") # Replace with function body.
