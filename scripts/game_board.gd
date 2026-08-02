extends Node2D
## Match-3 game board controller

signal score_changed(score: int)
signal moves_changed(remaining: int)
signal level_complete(stars: int)
signal combo_made(combo_type: String)

const GRID_OFFSET = Vector2(40, 140)
const CELL_SIZE = 72
const SWAP_SPEED = 0.15
const FALL_SPEED = 0.1

var _grid: Array = []             # [row][col] -> int (ItemType or -1)
var _cells: Array = []             # [row][col] -> Cell node
var _selected_cell: Vector2i = Vector2i(-1, -1)
var _is_processing: bool = false
var _score: int = 0
var _moves_remaining: int = 20
var _level_type: String = "score"
var _level_target: int = 1000
var _combo_multiplier: int = 1

# Reference to item scenes
var _item_scenes: Dictionary = {}

func _ready() -> void:
	_initialize_grid()
	_create_board()

func _initialize_grid() -> void:
	_grid = []
	_cells = []
	for row in Config.GRID_ROWS:
		_grid.append([])
		_cells.append([])
		for col in Config.GRID_COLS:
			_grid[row].append(-1)
			_cells[row].append(null)
	_populate_random()

func _populate_random() -> void:
	for row in Config.GRID_ROWS:
		for col in Config.GRID_COLS:
			var item = _get_random_item()
			_grid[row][col] = item
			_create_cell_item(row, col, item)

func _get_random_item() -> int:
	return randi() % 5  # 0-4 (BALL, EAGLE, STADIUM, JERSEY, TROPHY), STAR is special

func _create_cell_item(row: int, col: int, item_type: int) -> void:
	if _cells[row][col]:
		_cells[row][col].queue_free()

	var cell = _make_item_sprite(item_type)
	var pos = _grid_to_pos(row, col)
	cell.position = pos
	add_child(cell)
	_cells[row][col] = cell

func _make_item_sprite(item_type: int) -> Node2D:
	var node = Node2D.new()
	node.set_meta("item_type", item_type)

	# Background rounded rect
	var bg = ColorRect.new()
	bg.size = Vector2(CELL_SIZE - 4, CELL_SIZE - 4)
	bg.position = -(bg.size / 2)

	var base_color = Config.get_item_color(item_type)
	bg.color = base_color.darkened(0.3)
	node.add_child(bg)

	# SVG icon path
	var icon_paths = {
		Config.ItemType.BALL: "res://assets/icons/sprites/ball.svg",
		Config.ItemType.EAGLE: "res://assets/icons/sprites/eagle.svg",
		Config.ItemType.STADIUM: "res://assets/icons/sprites/stadium.svg",
		Config.ItemType.JERSEY: "res://assets/icons/sprites/jersey.svg",
		Config.ItemType.TROPHY: "res://assets/icons/sprites/trophy.svg",
		Config.ItemType.STAR: "res://assets/icons/sprites/star.svg",
	}

	if icon_paths.has(item_type):
		var tex = load(icon_paths[item_type])
		if tex:
			var sprite = Sprite2D.new()
			sprite.texture = tex
			sprite.scale = Vector2(0.6, 0.6)
			sprite.modulate = base_color
			node.add_child(sprite)

	return node

func _grid_to_pos(row: int, col: int) -> Vector2:
	return GRID_OFFSET + Vector2(col * CELL_SIZE, row * CELL_SIZE)

func _pos_to_grid(pos: Vector2) -> Vector2i:
	var local = pos - GRID_OFFSET
	var col = int(local.x / CELL_SIZE)
	var row = int(local.y / CELL_SIZE)
	return Vector2i(col, row)

# ─── Input ────────────────────────────────────────────

func _input(event: InputEvent) -> void:
	if _is_processing: return
	if event is InputEventMouseButton and event.pressed:
		var grid_pos = _pos_to_grid(event.position)
		if _is_valid_cell(grid_pos):
			_on_cell_tapped(grid_pos)

func _is_valid_cell(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < Config.GRID_COLS and pos.y >= 0 and pos.y < Config.GRID_ROWS

func _on_cell_tapped(pos: Vector2i) -> void:
	if _selected_cell.x == -1:
		_select_cell(pos)
	else:
		if _is_adjacent(_selected_cell, pos):
			_try_swap(_selected_cell, pos)
		else:
			_deselect_cell()
			_select_cell(pos)

func _is_adjacent(a: Vector2i, b: Vector2i) -> bool:
	return abs(a.x - b.x) + abs(a.y - b.y) == 1

func _select_cell(pos: Vector2i) -> void:
	_selected_cell = pos
	if _cells[pos.y][pos.x]:
		_cells[pos.y][pos.x].modulate = Color(1.0, 1.0, 1.0, 0.6)

func _deselect_cell() -> void:
	if _selected_cell.x != -1 and _cells[_selected_cell.y][_selected_cell.x]:
		_cells[_selected_cell.y][_selected_cell.x].modulate = Color.WHITE
	_selected_cell = Vector2i(-1, -1)

# ─── Swap ─────────────────────────────────────────────

func _try_swap(a: Vector2i, b: Vector2i) -> void:
	_is_processing = true
	_deselect_cell()
	_animate_swap(a, b)
	await get_tree().create_timer(SWAP_SPEED).timeout

	# Perform swap
	_swap_grid(a, b)

	# Check for matches
	var matches = _find_matches()
	if matches.size() > 0:
		_moves_remaining -= 1
		moves_changed.emit(_moves_remaining)
		await _process_matches(matches)
		await _fill_board()
		# Chain reactions
		while true:
			var new_matches = _find_matches()
			if new_matches.size() == 0: break
			_combo_multiplier += 1
			await _process_matches(new_matches)
			await _fill_board()
		_combo_multiplier = 1
		_check_level_complete()
	else:
		# Swap back
		_swap_grid(a, b)
		_animate_swap(a, b)
		await get_tree().create_timer(SWAP_SPEED).timeout

	_is_processing = false

func _swap_grid(a: Vector2i, b: Vector2i) -> void:
	var temp = _grid[a.y][a.x]
	_grid[a.y][a.x] = _grid[b.y][b.x]
	_grid[b.y][b.x] = temp

	var temp_cell = _cells[a.y][a.x]
	_cells[a.y][a.x] = _cells[b.y][b.x]
	_cells[b.y][b.x] = temp_cell

func _animate_swap(a: Vector2i, b: Vector2i) -> void:
	var tween = create_tween().set_parallel(true)
	if _cells[a.y][a.x]:
		tween.tween_property(_cells[a.y][a.x], "position", _grid_to_pos(a.y, a.x), SWAP_SPEED)
	if _cells[b.y][b.x]:
		tween.tween_property(_cells[b.y][b.x], "position", _grid_to_pos(b.y, b.x), SWAP_SPEED)

# ─── Match Detection ──────────────────────────────────

func _find_matches() -> Array:
	var matched: Array[Vector2i] = []

	# Horizontal matches
	for row in Config.GRID_ROWS:
		var col = 0
		while col < Config.GRID_COLS:
			if _grid[row][col] == -1: col += 1; continue
			var item = _grid[row][col]
			var end = col + 1
			while end < Config.GRID_COLS and _grid[row][end] == item: end += 1
			if end - col >= 3:
				for c in range(col, end):
					matched.append(Vector2i(c, row))
			col = end

	# Vertical matches
	for col in Config.GRID_COLS:
		var row = 0
		while row < Config.GRID_ROWS:
			if _grid[row][col] == -1: row += 1; continue
			var item = _grid[row][col]
			var end = row + 1
			while end < Config.GRID_ROWS and _grid[end][col] == item: end += 1
			if end - row >= 3:
				for r in range(row, end):
					matched.append(Vector2i(col, r))
			row = end

	# Deduplicate
	var seen: Dictionary = {}
	var unique: Array[Vector2i] = []
	for pos in matched:
		var key = "%d,%d" % [pos.x, pos.y]
		if not seen.has(key):
			seen[key] = true
			unique.append(pos)

	return unique

# ─── Process Matches ──────────────────────────────────

func _process_matches(matches: Array) -> void:
	var largest = matches.size()

	# Detect combos
	if largest >= 10:
		combo_made.emit("T_shape")  # large special
	elif largest >= 7:
		combo_made.emit("L_shape")
	elif largest >= 5:
		combo_made.emit("5_row")
	elif largest >= 4:
		combo_made.emit("4_row")

	# Score
	var points = largest * 10 * _combo_multiplier
	_score += points
	score_changed.emit(_score)

	# Animate removal
	for pos in matches:
		if _cells[pos.y][pos.x]:
			var tween = create_tween()
			tween.tween_property(_cells[pos.y][pos.x], "scale", Vector2.ZERO, 0.15)
			tween.tween_callback(_cells[pos.y][pos.x].queue_free)
			_cells[pos.y][pos.x] = null
			_grid[pos.y][pos.x] = -1

	await get_tree().create_timer(0.2).timeout

# ─── Fill Board ───────────────────────────────────────

func _fill_board() -> void:
	# Shift existing items down
	for col in Config.GRID_COLS:
		var write_row = Config.GRID_ROWS - 1
		for row in range(Config.GRID_ROWS - 1, -1, -1):
			if _grid[row][col] != -1:
				if write_row != row:
					_grid[write_row][col] = _grid[row][col]
					_cells[write_row][col] = _cells[row][col]
					_grid[row][col] = -1
					_cells[row][col] = null
					if _cells[write_row][col]:
						var tween = create_tween()
						tween.tween_property(_cells[write_row][col], "position", _grid_to_pos(write_row, col), FALL_SPEED)
				write_row -= 1

		# Fill empty cells from top
		for row in range(write_row, -1, -1):
			var item = _get_random_item()
			_grid[row][col] = item
			_create_cell_item(row, col, item)
			# Animate fall from above
			_cells[row][col].position = GRID_OFFSET + Vector2(col * CELL_SIZE, -CELL_SIZE)
			var tween = create_tween()
			tween.tween_property(_cells[row][col], "position", _grid_to_pos(row, col), FALL_SPEED + (write_row - row) * 0.05)

	await get_tree().create_timer(0.2).timeout

# ─── Level Complete ───────────────────────────────────

func _check_level_complete() -> void:
	var stars = 0
	if _score >= _level_target * 0.5: stars = 1
	if _score >= _level_target * 1.5: stars = 2
	if _score >= _level_target * 2.0: stars = 3

	if stars >= 1 and _moves_remaining <= 0:
		level_complete.emit(stars)
	elif stars >= 3:
		level_complete.emit(stars)

func setup_level(level_type: String, target: int, moves: int) -> void:
	_level_type = level_type
	_level_target = target
	_moves_remaining = moves
	_score = 0
	moves_changed.emit(_moves_remaining)
	score_changed.emit(_score)

# ─── Power-Ups ────────────────────────────────────────

func use_hammer(pos: Vector2i) -> void:
	_cells[pos.y][pos.x].queue_free()
	_cells[pos.y][pos.x] = null
	_grid[pos.y][pos.x] = -1
	await _fill_board()

func use_bomb(pos: Vector2i) -> void:
	for row in range(maxi(0, pos.y - 1), mini(Config.GRID_ROWS, pos.y + 2)):
		for col in range(maxi(0, pos.x - 1), mini(Config.GRID_COLS, pos.x + 2)):
			if _cells[row][col]:
				_cells[row][col].queue_free()
				_cells[row][col] = null
				_grid[row][col] = -1
	await _fill_board()
