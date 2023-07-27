@tool
extends Control


func _draw():
	var rect = self.get_rect()
	var width = 4;
	var radius = width / 2.0
	var color = Color.WHITE
	rect.position += Vector2.ONE * radius
	rect.size -= 2 * Vector2.ONE * radius
	draw_line(rect.position, rect.position + rect.size, color, width)
	draw_line(rect.position + Vector2(rect.size.x, 0), rect.position + Vector2(0, rect.size.y), color, width)
	draw_circle(rect.position, radius, color)
	draw_circle(rect.position + Vector2(rect.size.x, 0), radius, color)
	draw_circle(rect.position + Vector2(0, rect.size.y), radius, color)
	draw_circle(rect.position + rect.size, radius, color)
