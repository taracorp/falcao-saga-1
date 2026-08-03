extends Control

const COLS = 8
const ROWS = 8
const CELL = 85
const OX = 20
const OY = 70

var grid = []
var _swap_c1=0; var _swap_r1=0; var _swap_c2=0; var _swap_r2=0
var selected = null
var score = 0
var moves = 20
var busy = false

var colors = [
	Color(0.0, 0.6, 0.35), Color(1.0, 0.75, 0.0), Color(0.35, 0.35, 0.45),
	Color(0.95, 0.95, 0.95), Color(0.9, 0.65, 0.15), Color(1.0, 0.88, 0.0),
]

func _ready():
	$GridLayer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main.tscn"))
	$BtnHammer.pressed.connect(func(): _buy(150, "hammer"))
	$BtnBomb.pressed.connect(func(): _buy(300, "bomb"))
	$BtnMoves.pressed.connect(func(): _buy(200, "moves"))
	_init_grid()

func _buy(cost, _type):
	if GameManager.spend_coins(cost):
		if _type=="moves": moves+=5; $Moves.text="Moves: %d"%moves

func _init_grid():
	for r in ROWS:
		grid.append([])
		for c in COLS: grid[r].append(randi()%6)
	_draw_grid()

func _draw_grid():
	for c in $GridLayer.get_children(): c.queue_free()
	for r in ROWS:
		for cc in COLS:
			var rect = ColorRect.new()
			var x=OX+cc*CELL; var y=OY+r*CELL
			rect.offset_left=x; rect.offset_top=y
			rect.offset_right=x+CELL-3; rect.offset_bottom=y+CELL-3
			rect.color=colors[grid[r][cc]]
			rect.set_meta("row",r); rect.set_meta("col",cc)
			$GridLayer.add_child(rect)

func _input(event):
	if busy: return
	if event is InputEventMouseButton and event.pressed:
		var pos=event.position
		var c=int((pos.x-OX)/CELL); var r=int((pos.y-OY)/CELL)
		if c<0 or c>=COLS or r<0 or r>=ROWS: return
		if selected==null:
			selected=Vector2(c,r); _highlight(c,r)
		else:
			var sc=selected
			if abs(sc.x-c)+abs(sc.y-r)==1:
				_unhighlight(sc.x,sc.y); _swap(sc.x,sc.y,c,r)
			else:
				_unhighlight(sc.x,sc.y); selected=Vector2(c,r); _highlight(c,r)

func _highlight(c,r):
	for child in $GridLayer.get_children():
		if child is ColorRect and child.get_meta("col")==c and child.get_meta("row")==r:
			child.modulate=Color(1.5,1.5,1.5)

func _unhighlight(c,r):
	for child in $GridLayer.get_children():
		if child is ColorRect and child.get_meta("col")==c and child.get_meta("row")==r:
			child.modulate=Color(1,1,1)

func _swap(c1,r1,c2,r2):
	busy=true
	_swap_c1=c1;_swap_r1=r1;_swap_c2=c2;_swap_r2=r2
	var tmp=grid[r1][c1];grid[r1][c1]=grid[r2][c2];grid[r2][c2]=tmp
	_draw_grid()
	moves-=1;$Moves.text="Moves: %d"%moves
	_check_matches()

func _check_matches():
	var matched=[]
	for r in ROWS:
		var c=0
		while c<COLS:
			var t=grid[r][c];var end=c
			while end<COLS and grid[r][end]==t:end+=1
			if end-c>=3:
				for cc in range(c,end):matched.append(Vector2(cc,r))
			c=end
	for c in COLS:
		var r=0
		while r<ROWS:
			var t=grid[r][c];var end=r
			while end<ROWS and grid[end][c]==t:end+=1
			if end-r>=3:
				for rr in range(r,end):matched.append(Vector2(c,rr))
			r=end
	if matched.size()>=3:
		var pts={}
		for m in matched:pts["%d,%d"%[m.x,m.y]]=true
		score+=pts.size()*10;$Score.text="Score: %d"%score
		for key in pts:
			var cc=int(key.split(",")[0]);var rr=int(key.split(",")[1])
			grid[rr][cc]=randi()%6
		await get_tree().create_timer(0.15).timeout
		_draw_grid()
		await get_tree().create_timer(0.1).timeout
		_check_matches()
	else:
		var tmp=grid[_swap_r1][_swap_c1]
		grid[_swap_r1][_swap_c1]=grid[_swap_r2][_swap_c2]
		grid[_swap_r2][_swap_c2]=tmp
		_draw_grid();moves+=1;$Moves.text="Moves: %d"%moves
	busy=false;selected=null
