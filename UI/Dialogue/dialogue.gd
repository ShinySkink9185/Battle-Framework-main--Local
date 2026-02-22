extends Control

# Sonic Battle Dialogue
# by ShinySkink9185
# This was borrowed from my Klonoa Project Test.
# I hope Mobi doesn't mind me shilling it...

# Labels for text.
@onready var textLabel = $CanvasLayer/Text
@onready var animation = $AnimationPlayer

# Sound banks.
@onready var soundBankTalk = $AudioStreamTalk
@onready var soundBankExtra = $AudioStreamExtra

# Timer before next letter.
var letterTimer := 0.0
# Storage of dialogue that's yet to be printed.
var currentDialogue: String = ""
# Can the player advance the text?
var confirmOption = false
# List of dialogue on storage
var dialogueList := []
# Did the textbox just appear? Used to prevent things breaking.
var justStarted = true
# Is the text currently going at fast pace?
var goingFast = false
# Toggles the black background showing up or not.
var paperMarioMode = false

# These can be changed depending on Speaker settings.
var talkSound = "res://assets/audio/sfx/Dialogue/DialogueRegular.wav"

# TODO: make fadeouts a thing.
# Fadeout length is usually 33 frames out of 60.

# Default is 5 frames.
const TEXTSPEED = (1.0/60.0) * 5.0
const TEXTSPEEDFAST = (1.0/60.0)

func _init():
	# testing dialogue, remove later
	defineDialogue("Testing 1!", true)
	defineDialogue("Testing 2!", true)
	defineDialogue("This text is really long and boring...")

func _physics_process(delta):
	# Keep refreshing until the first bit of dialogue appears.
	
	if justStarted == true and not currentDialogue:
		if dialogueList and animation.current_animation == "Idle":
			currentDialogue = dialogueList[0].dialogue
			justStarted = false
		return
	
	if currentDialogue.length() > 0:
		if letterTimer <= 0:
			# Prints the first letter into box
			textLabel.text += currentDialogue.left(1)
			if goingFast == true:
				letterTimer = TEXTSPEEDFAST
			else:
				letterTimer = TEXTSPEED
			# Erases first letter of stored dialogue
			currentDialogue = currentDialogue.erase(0)
			# Play the dialogue sound
			soundBankTalk.play()
		else:
			letterTimer -= delta
	elif justStarted == false:
		confirmOption = true
	
	# Speed up the textbox, advance it, or delete it.
	if Input.is_action_just_pressed("jump1"):
		if confirmOption == true:
			confirmOption = false
			# Remove the last used object.
			dialogueList.remove_at(0)
			# Remove speed-up mode.
			goingFast = false
			# If that's all the dialogue, remove the textbox.
			if not dialogueList:
				# TODO: add option for either just deleting it or
				# doing the regular dialogue exit
				animation.play("Exiting")
			else:
				# Get the text currently in the box to disappear.
				if dialogueList[0].refreshBox == true:
					textLabel.text = ""
			
				currentDialogue = dialogueList[0].dialogue
		else:
			# Speed up the text.
			goingFast = true
		
# Adds a dialogueEntry class that stores all the info of a single piece of dialogue
class dialogueEntry:
	# Our info
	var dialogue: String = ""
	var refreshBox: bool = true
	
	# Parameterized constructor
	func _init(setDialogue: String = "", setRefreshBox: bool = true):
		dialogue = setDialogue
		refreshBox = setRefreshBox

# Adds new dialogue to the queue using the class
func defineDialogue(setDialogue: String, setRefreshBox: bool = true):
	# Instantiate a class
	var dialogue = dialogueEntry.new(setDialogue, setRefreshBox)
	# Then, insert that object into our array!
	dialogueList.append(dialogue);

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Initial":
		animation.play("Idle")
	elif anim_name == "Exiting":
		queue_free()
