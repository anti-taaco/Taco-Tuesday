extends ProgressBar

@onready var camera = $".."

var timer = 0
var stamina = 0

func _process(delta: float)->void :
    value = camera.stamina
