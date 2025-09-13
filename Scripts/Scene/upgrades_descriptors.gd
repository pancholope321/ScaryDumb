extends HBoxContainer
var config_gun=""
var config_name=""
var current_progress
var newSettedValue=0
var saved_text=""
var upgrade_cost=0
var currentFolder=""

func _ready() -> void:
	var currentFolderSet=FileAccess.open("user://current_file.txt",FileAccess.READ)
	currentFolder=currentFolderSet.get_as_text()

# Called when the node enters the scene tree for the first time.
func set_upgrade_values(text,progress,config_gun_set,config_name_set):
	get_node("Label").text=text
	get_node("progress").value=progress+1
	saved_text=text
	current_progress=progress
	config_name=config_name_set
	config_gun=config_gun_set
	var alreadyConnected=true
	var config=ConfigFile.new()
	config.load("res://Scenes/UpgradesData/newListOfupgrades.cfg")
	var newString=""
	for section in config.get_section_keys("text"):
		newString=newString+config.get_value("text",section)+","
	#print(newString)
	var fullCSV=fileParser(newString)
	var sizeOfCSV=fullCSV.size()
	var actualIndex=0
	while actualIndex<sizeOfCSV-1:
		actualIndex+=1
		var csv = fullCSV[actualIndex]
		if csv.size()>1:
			if csv[0] == config_gun and csv[1]==config_name and int(csv[3])==int(current_progress)+1:
				upgrade_cost=int(csv[4])
				get_node("Button").connect("pressed",change_the_current_value)
				newSettedValue=csv[2]
				alreadyConnected=false
				get_node("Button").text="UPGRADE \n" + str(upgrade_cost)
			elif alreadyConnected:
				if get_node("Button").is_connected("pressed",change_the_current_value):
					get_node("Button").disconnect("pressed",change_the_current_value)
			
			pass
	pass
func fileParser(string):
	var listOfLists=[]
	var firstList=[]
	var element=""
	for charac in string:
		if charac==";":
			firstList.append(element)
			element=""
		elif charac=="\r":
			continue
		elif charac==",":
			firstList.append(element)
			listOfLists.append(firstList)
			firstList=[]
			element=""
		else:
			element=element+charac
	return(listOfLists)

func change_the_current_value():
	var config = ConfigFile.new()
	var err = config.load("user://saves/"+currentFolder+"/default.cfg")
	if err != OK:
		return
	var dispGold=config.get_value("gold","quantity")
	if upgrade_cost<=int(dispGold):
		config.set_value("gold","quantity",dispGold-upgrade_cost)
		current_progress+=1
		get_node("progress").value=current_progress+1
		config.set_value(config_gun, config_name,current_progress)
		var allNames=config.get_value("identificator","names")
		var index=0
		var realindex=-1
		#print(config_name)
		#print(allNames)
		for oneName in allNames:
			if oneName==config_name:
				realindex=index
			index+=1
		if realindex!=-1:
			var theValueThatIsChanged=config.get_value(config_gun,"values")
			
			#print(newSettedValue)
			#print(theValueThatIsChanged)
			theValueThatIsChanged[realindex]=float(newSettedValue)
			#print(theValueThatIsChanged)
			
			config.set_value(config_gun, "values",theValueThatIsChanged)
		config.save("user://saves/"+currentFolder+"/default.cfg")
		set_upgrade_values(saved_text,current_progress,config_gun,config_name)
		get_tree().call_group("goldManager","update_data")
