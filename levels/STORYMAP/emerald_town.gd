extends Node2D

var dialogueScene = load("res://UI/Dialogue/dialogue.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dialogue = dialogueScene.instantiate(true)
	dialogue.backgroundShade = false
	dialogue.addSpeaker("Tails", 0, 1, "Left", "Right")
	dialogue.addDialogue("Testing 1!", 3)
	dialogue.addDialogue("Testing 2!")
	dialogue.addSpeaker("Sonic", 0, 1, "Right", "Left")
	dialogue.addDialogue("This text is really long and boring...")
	add_child(dialogue)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
