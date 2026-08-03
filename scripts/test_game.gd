extends Control

const COLS = 8
const ROWS = 8
const CELL = 68
const GAP = 4
const OX = 36
const OY = 70

var grid = []
var selected = null
var score = 0
var moves = 20
var busy = false
var _swap_c1 = 0
var _swap_r1 = 0
var _swap_c2 = 0
var _swap_r2 = 0

var colors = [
	Color(0.0, 0.5, 0.3),  # green
	Color(0.9, 0.7, 0.0),  # gold
	Color(0.3, 0.3, 0.4),  # grey
	Color(0.95, 0.95, 0.95), # white
	Color(0.85, 0.6, 0.1),  # bronze
	Color(0.95, 0.85, 0.0),  # bright gold
]
var icons = ["⚽","🦅","🏟","👕","🏆","⭐"]

func _ready():
	$Back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main.tscn"))
	_init_grid()

func _init_grid():
	for r in ROWS:
		grid.append([])
		for c in COLS:
			var t = randi() % 6
			grid[r].append(t)
	_draw_grid()

func _draw_grid():
	for c in get_children():
		if c is ColorRect and c != $BG and c != $Moves and c != $Score and c != $Back: c.queue_free()
	for r in ROWS:
		for cc in COLS:
			var rect = ColorRect.new()
			var x = OX + cc*(CELL+GAP)
			var y = OY + r*(CELL+GAP)
			rect.offset_left = x
			rect.offset_top = y
			rect.offset_right = x + CELL
			rect.offset_bottom = y + CELL
			rect.color = colors[grid[r][cc]]
			rect.set_meta("row", r)
			rect.set_meta("col", cc)
			var label = Label.new()
			label.text = icons[grid[r][cc]]
			label.offset_left = 0
			label.offset_top = 0
			label.offset_right = CELL
			label.offset_bottom = CELL
			label.horizontal_alignment = 1
			label.vertical_alignment = 1
			label.add_theme_font_size_override("font_size", 22)
			rect.add_child(label)
			add_child(rect)

func _input(event):
	if busy: return
	if event is InputEventMouseButton and event.pressed:
		var pos = event.position
		var c = int((pos.x - OX) / (CELL + GAP))
		var r = int((pos.y - OY) / (CELL + GAP))
		if c < 0 or c >= COLS or r < 0 or r >= ROWS: return
		if selected == null:
			selected = Vector2(c, r)
			_highlight(c, r)
		else:
			var sc = selected
			var diff = abs(sc.x - c) + abs(sc.y - r)
			if diff == 1:
				_unhighlight(sc.x, sc.y)
				_swap(sc.x, sc.y, c, r)
			else:
				_unhighlight(sc.x, sc.y)
				selected = Vector2(c, r)
				_highlight(c, r)

func _highlight(c, r):
	for child in get_children():
		if child is ColorRect and child.get_meta("col") == c and child.get_meta("row") == r:
			child.material = null
			child.modulate = Color(1.5, 1.5, 1.5)

func _unhighlight(col, row):
	for child in get_children():
		if child is ColorRect and child.get_meta("col") == col and child.get_meta("row") == row:
			child.modulate = Color(1, 1, 1)

func _swap(c1, r1, c2, r2):
	busy = true
	_swap_c1 = c1; _swap_r1 = r1; _swap_c2 = c2; _swap_r2 = r2
	var tmp = grid[r1][c1]
	grid[r1][c1] = grid[r2][c2]
	grid[r2][c2] = tmp
	_draw_grid()
	moves -= 1
	$Moves.text = "Moves: %d" % moves
	_check_matches()

func _check_matches():
	var matched = []
	for r in ROWS:
		var c = 0
		while c < COLS:
			var t = grid[r][c]
			var end = c
			while end < COLS and grid[r][end] == t: end += 1
			if end - c >= 3:
				for cc in range(c, end): matched.append(Vector2(cc, r))
			c = end
	for c in COLS:
		var r = 0
		while r < ROWS:
			var t = grid[r][c]
			var end = r
			while end < ROWS and grid[end][c] == t: end += 1
			if end - r >= 3:
				for rr in range(r, end): matched.append(Vector2(c, rr))
			r = end
	if matched.size() >= 3:
		var pts = {}
		for m in matched: pts["%d,%d"%[m.x,m.y]] = true
		score += pts.size() * 10
		$Score.text = "Score: %d" % score
		for key in pts:
			var parts = key.split(",")
			var cc = int(parts[0]); var rr = int(parts[1])
			grid[rr][cc] = randi() % 6
		await get_tree().create_timer(0.2).timeout
		_draw_grid()
		await get_tree().create_timer(0.1).timeout
		_check_matches()
	else:
		var tmp = grid[_swap_r1][_swap_c1]
		grid[_swap_r1][_swap_c1] = grid[_swap_r2][_swap_c2]
		grid[_swap_r2][_swap_c2] = tmp
		_draw_grid()
		moves += 1
		$Moves.text = "Moves: %d" % moves
	busy = false
	selected = null
