extends HBoxContainer

var currentFolder=""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var currentFolderSet=FileAccess.open("user://current_file.txt",FileAccess.READ)
	currentFolder=currentFolderSet.get_as_text()
	update_data()


func update_data():
	var config = ConfigFile.new()
	var err = config.load("user://saves/"+currentFolder+"/default.cfg")
	if err != OK:
		return
	var dispGold=config.get_value("gold","quantity")
	get_node("goldNumber").text=str(dispGold)
