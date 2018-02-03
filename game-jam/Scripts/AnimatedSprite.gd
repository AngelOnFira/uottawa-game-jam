extends AnimatedSprite
var timeElapsed = 0

func _ready():
	set_process(true)
	set_frame(0)
	
func _process(delta):
	timeElapsed += delta
	
	while(timeElapsed > 0.1 and Input.is_action_pressed("ui_right")):
		if(get_frame() == self.get_sprite_frames().get_frame_count("AnimatedSprite") - 1):
			set_frame(0)
		else:
			set_frame(get_frame() + 1)
	
		timeElapsed = 0