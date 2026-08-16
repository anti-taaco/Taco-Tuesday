extends AudioStreamPlayer2D

var timer = 1

@onready var player = $".."

func _process(delta: float)->void :
	randomize()

func playDash():
	var rand = randf_range(1, 1.3)
	$Dodge2.set_pitch_scale(rand)
	$Dash.set_pitch_scale(rand - 0.4)
	$Dodge2.play()
	$Dash.play()

func playShoot(num):
	if num == 0:
		var rand = randf_range(0.9, 1.15)
		$Shoot1.set_pitch_scale(rand)
		$Shoot1.play()
	if num == 1:
		var rand = randf_range(0.85, 1.15)
		$Shoot2.set_pitch_scale(rand)
		$Shoot2.play()

func playWalk():
	if player.walkDirection != 0:
		timer -= player.direction * 100
		if - timer >= - player.moveSpeed and timer <= player.moveSpeed:
			var rand = randf_range(0.75, 1.25)
			$Footstep1.set_pitch_scale(rand)
			$Footstep1.play()
			timer = 3000
	else:
		timer = 3000

func playWall():
	if not $Wallcling.playing:
		$Wallcling.play()

func stopWall():
	$Wallcling.stop()
