extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var blocks = []
var mid = false
var chunkSize = 1050
var chunks = []
var nextChunk
var lastChunk
var currentChunk
var numLoadedChunk = 0
var startChunk = preload("../Scenes/Chunks/startChunk.tscn")


func _ready():
	_preload_chunks()
	self.add_child(startChunk.instance())
	currentChunk = startChunk.instance()

func _process(delta):
	var camX = int($Camera.position.x) % chunkSize

	if (camX > 500 and mid == false):

		mid = true
		_delete_last_chunk()
		_load_next_chunk()
		
	if (camX < 500 and mid == true):
		mid = false
	
func _load_next_chunk():

	var thisChunk
	var random = randi() % chunks.size() - 1
	lastChunk = currentChunk
	currentChunk = nextChunk
	nextChunk = chunks[random].instance()
	numLoadedChunk +=1
	nextChunk.position.x = numLoadedChunk * 1050
	self.add_child(nextChunk)

func _delete_last_chunk():
	if lastChunk:
		lastChunk.queue_free()
	
func _preload_chunks():
	var path = "Scenes/Chunks/"
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.begins_with("Chunk"):
			print("../Scenes/Chunks/" + file)
			chunks.append(load("res://Scenes/Chunks/" + file))
			
	dir.list_dir_end()
	print (chunks)
