extends Control
## A dialogue system set up like that of Sonic Battle (GBA).
## When instantiating this node, there are certain variables you can set before
## you make the dialogue appear as a child.
##
## To use this, simply drag and drop this Scene from the file system
## into the map you want to use the dialogue in.
##
## Created by ShinySkink9185, being borrowed from Klonoa Project Test.
## I hope Mobi doesn't mind me shilling it...!

# Labels for text.
@onready var textLabel = $CanvasLayer/Text
@onready var animationTextbox = $AnimationPlayerTextbox
@onready var animationShade = $AnimationPlayerShade

# Sound banks.
@onready var soundBankTalk = $AudioStreamTalk
@onready var soundBankExtra = $AudioStreamExtra

var letterTimer := 0.0 ## Time before the next letter is printed.
var currentDialogue: String = "" ## Dialogue storage in memory that's yet to be printed.
var confirmOption = false ## Can the player advance the text?
var dialogueList := [] ## List of all dialogue currently on storage.
var speakerList := [] ## List of all Speakers currently on storage.
var justStarted = true ## Did this textbox just start existing? Prevents things from breaking.
var goingFast = false ## Is the text advancing at high speed?
var backgroundShade = false ## Will the black background shade take effect? Can be modified before adding.

enum textBoxShape {JAGGED1, JAGGED2, JAGGED3, NARRATION} ## Determines shape of the textbox.
enum speakerPosition {LEFT = 1, CENTER = 2, MIDDLE = 2, RIGHT = 3}
enum speakerDirection {LEFT = 1, RIGHT = 2}
enum speakerEnterMode {LEFT = 1, RIGHT = 2, FADE = 3}
enum speakerExitMode {LEFT = 1, RIGHT = 2, FADE = 3}

var talkSound = "res://assets/audio/sfx/Dialogue/DialogueRegular.wav" ## The talk sound that's currently being used.

# TODO: make fadeouts a thing.
# Fadeout length is usually 33 frames out of 60.

# Default is 5 frames.
const TEXTSPEED = (1.0/60.0) * 5.0
const TEXTSPEEDFAST = (1.0/60.0)

func _init(setBackgroundShade: bool = false):
	# Set Paper Mario Mode animations.
	backgroundShade = setBackgroundShade
	if backgroundShade == true:
		animationShade.play("Initial")

func _physics_process(delta):
	# Keep refreshing until the first bit of dialogue appears.
	if justStarted == true and not currentDialogue:
		if dialogueList and animationTextbox.current_animation == "Idle":
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
				animationTextbox.play("Exiting")
				# Taking away the background shade
				if backgroundShade:
					animationShade.play("Exiting")
			else:
				# Get the text currently in the box to disappear.
				if dialogueList[0].refreshBox == true:
					textLabel.text = ""
			
				currentDialogue = dialogueList[0].dialogue
		else:
			# Speed up the text.
			goingFast = true
		
# Adds a DialogueEntry class that stores all the info of a single piece of dialogue
class DialogueEntry:
	# Our info
	var dialogue: String = ""
	var refreshBox: bool = true
	
	# Parameterized constructor
	func _init(setDialogue: String = "", setRefreshBox: bool = true):
		dialogue = setDialogue
		refreshBox = setRefreshBox

# Adds new dialogue to the queue using the class
func addDialogue(setDialogue: String, setRefreshBox: bool = true):
	# Instantiate a class
	var dialogue = DialogueEntry.new(setDialogue, setRefreshBox)
	# Then, insert that object into our array!
	dialogueList.append(dialogue);

# Speaker class that defines a Speaker.
class DialogueSpeaker:
	var name: String
	var poses: Array[String]
	var poseCoordinates: Array[Vector2]
	var sound: String
	
	# Parameterized constructor
	func _init(setName: String, setPoses: Array[String], setPoseCoordinates: Array[Vector2] = [Vector2(0, 0)], setSound: String = "res://assets/audio/sfx/Dialogue/DialogueRegular.wav"):
		name = setName
		poses = setPoses
		poseCoordinates = setPoseCoordinates
		# TODO: if number of coordinates is less than amount of poses,
		# append Vector2(0, 0) values to the array until we get there
		sound = setSound

# This defines a speaker.
func defineSpeaker(setName: String, setPoses: Array[String], setPoseCoordinates: Array[Vector2] = [Vector2(0, 0)], setSound: String = "res://assets/audio/sfx/Dialogue/DialogueRegular.wav"):
	var speaker = DialogueSpeaker.new(setName, setPoses, setPoseCoordinates, setSound)
	speakerList.append(speaker)

func addSpeaker(setName: String, setPose: int, setPosition: int, setEnterMode: int, setDirection: int, setDelay: bool = true):
	pass

# Animations for the textbox.
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Initial":
		animationTextbox.play("Idle")
	elif anim_name == "Exiting":
		queue_free()

# Animations for the background shade.
func _on_animation_player_shade_animation_finished(anim_name):
	if anim_name == "Initial":
		animationShade.play("Idle")
	elif anim_name == "Exiting":
		queue_free()
