extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	#self.position = self.get_parent().get_node("Camera").position
	$Label.text = str(int(self.get_parent().get_node("Camera").position.x / 50))
