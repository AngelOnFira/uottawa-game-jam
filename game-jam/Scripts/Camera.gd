extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


func _ready():
	
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _process(delta):
	self.position.x += min(200 * delta + (self.position.x * delta * 0.05), 8)