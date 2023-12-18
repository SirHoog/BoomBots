extends Camera2D

var mouseStartPos : Vector2
var screenStartPos : Vector2

var dragging : bool = false

func _input(event):
	# Dragging
	if event.is_action("DragCamera") and event.is_pressed():
		dragging = true
		
		mouseStartPos = event.position
		screenStartPos = position
	elif event is InputEventMouseMotion and dragging:
		position = zoom * (mouseStartPos - event.position) + screenStartPos
	else:
		dragging = false
	
	# Zooming
	zoom += Vector2(Input.get_axis("ZoomOut", "ZoomIn") * 0.5, Input.get_axis("ZoomOut", "ZoomIn") * 0.5)
