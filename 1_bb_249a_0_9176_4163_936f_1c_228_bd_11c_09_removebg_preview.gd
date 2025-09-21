extends Sprite2D

func _process(delta: float) -> void:
	if $"../mouse".velocity.x:
		visible = false
		$"../066028346a0740Bee921342149d76500".visible = false
		$"../Label2".visible = false
		$"../Label".visible = false
	
