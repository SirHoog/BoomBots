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
		position = (mouseStartPos - event.position) / zoom + screenStartPos
	else:
		dragging = false
	
	# Zooming
	zoom *= 2 ** Input.get_axis("ZoomOut", "ZoomIn") # 2 ^ x # Zoom in twice or half as much as before
