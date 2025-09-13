extends Control


# buscar el nombre de todos los archivos saved, guardarlo en una variable y displayearlo
# en el richTextLabel
var savedName="Save 1"
var savedPath="user://Save 1.cfg"
func _ready() -> void:
	var dirA=DirAccess
	var err = dirA.dir_exists_absolute("user://saves")
	if !err:
		print("we are creating the dir")
		dirA.make_dir_absolute("user://saves")
	var directories=dirA.get_directories_at("user://saves")
	for direct in directories:
		var newButton=Button.new()
		newButton.text=direct
		get_node("savedFilesMenu/savedFiles/allSavedFiles").add_child(newButton)
		newButton.connect("pressed",set_current_file.bind(direct))
		
		var deleteButton=Button.new()
		deleteButton.text=direct
		get_node("deleteFilesMenu/savedFiles/allSavedFiles").add_child(deleteButton)
		deleteButton.connect("pressed",delete_file.bind(direct,newButton,deleteButton))
		

func _on_new_game_pressed() -> void:
	get_node("firstMenu").visible=false # Replace with function body.
	get_node("newGameMenu").visible=true

func _on_saved_files_pressed() -> void:
	get_node("firstMenu").visible=false # Replace with function body.
	get_node("savedFilesMenu").visible=true


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_start_saved_file_pressed() -> void:
	var text=get_node("newGameMenu/LineEdit").text
	text=filterCharacters(text)
	if checkIfSaveIsNotCreated(text):
		var file=FileAccess.open("user://current_file.txt",FileAccess.WRITE)
		file.store_string(text)
		file.close()
		DirAccess.make_dir_absolute("user://saves/"+text)
		get_tree().change_scene_to_file("res://Scenes/upgrade_menu.tscn")
	else:
		get_node("newGameMenu/warning").visible=true
	pass # Replace with function body.


func filterCharacters(text):
	var listOfCharPermitted="qwertyuiopasdfghjklzxcvbnm. !1234567890_"
	var newText=""
	for chara in text:
		if chara in listOfCharPermitted:
			newText=newText+chara
	return newText


func checkIfSaveIsNotCreated(text):
	var dir=DirAccess
	if dir.dir_exists_absolute("user://saves/"+text):
		return false
	else:
		return true
	
	
func set_current_file(fileName):
	var file=FileAccess.open("user://current_file.txt",FileAccess.WRITE)
	file.store_string(fileName)
	file.close()
	get_tree().change_scene_to_file("res://Scenes/upgrade_menu.tscn")

func delete_file(fileName,button,secondButton):
	var dir = DirAccess.open("user://saves/"+fileName)
	for file in dir.get_files():
		dir.remove(file)
	DirAccess.remove_absolute("user://saves/"+fileName)
	button.queue_free()
	secondButton.queue_free()


func _on_delete_files_pressed() -> void:
	get_node("firstMenu").visible=false # Replace with function body.
	get_node("deleteFilesMenu").visible=true
