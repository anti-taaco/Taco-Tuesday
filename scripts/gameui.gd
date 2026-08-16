extends CanvasLayer

@onready var healthbar = $Healthbar

var playerHP = 100
var maxHP = 100
var damage = 0
var stamina = 0
var slot = 1
var fireCD = 0
var fireRate = 0
var ammo = 0
var maxAmmo = 0

func _process(delta: float)->void :

	if playerHP <= 0:
		playerHP = 0
	$Label.text = "Ammo: " + str(ammo) + "/" + str(maxAmmo)
	$Label2.text = "Reload: " + str(fireCD) + "/" + str(fireRate)
	$Label4.text = "Slot: " + str(slot)

func healthTimerReset():
	healthbar.timer = 0
