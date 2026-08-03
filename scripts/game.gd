extends Control

const ROWS=8; const COLS=8; const CELL=74; const OX=40; const OY=190
var grid=[]; var sel=null; var score=0; var moves=24; var busy=false
var _c1=0;var _r1=0;var _c2=0;var _r2=0

var colors=[Color(0,0.5,0.3),Color(0.9,0.7,0),Color(0.35,0.35,0.45),Color(0.95,0.95,0.95),Color(0.85,0.6,0.1),Color(1,0.85,0)]

func _ready():
	$GridLayer.mouse_filter=Control.MOUSE_FILTER_IGNORE
	$Back.pressed.connect(func():get_tree().change_scene_to_file("res://scenes/03_beranda.tscn"))
	for r in ROWS: grid.append([]); for c in COLS: grid[r].append(randi()%6)
	_draw()

func _draw():
	for c in $GridLayer.get_children(): c.queue_free()
	for r in ROWS: for cc in COLS:
		var rect=ColorRect.new()
		var x=OX+cc*CELL;var y=OY+r*CELL
		rect.offset_left=x;rect.offset_top=y;rect.offset_right=x+CELL-3;rect.offset_bottom=y+CELL-3
		rect.color=colors[grid[r][cc]]
		rect.set_meta("r",r);rect.set_meta("c",cc)
		$GridLayer.add_child(rect)

func _input(event):
	if busy:return
	if event is InputEventMouseButton and event.pressed:
		var c=int((event.position.x-OX)/CELL);var r=int((event.position.y-OY)/CELL)
		if c<0 or c>=COLS or r<0 or r>=ROWS:return
		if sel==null: sel=Vector2(c,r);_hl(c,r)
		else:
			var sc=sel
			if abs(sc.x-c)+abs(sc.y-r)==1:_unhl(sc.x,sc.y);_swap(sc.x,sc.y,c,r)
			else:_unhl(sc.x,sc.y);sel=Vector2(c,r);_hl(c,r)

func _hl(c,r):
	for ch in $GridLayer.get_children():
		if ch is ColorRect and ch.get_meta("c")==c and ch.get_meta("r")==r:ch.modulate=Color(1.5,1.5,1.5)
func _unhl(c,r):
	for ch in $GridLayer.get_children():
		if ch is ColorRect and ch.get_meta("c")==c and ch.get_meta("r")==r:ch.modulate=Color(1,1,1)

func _swap(c1,r1,c2,r2):
	busy=true;_c1=c1;_r1=r1;_c2=c2;_r2=r2
	var t=grid[r1][c1];grid[r1][c1]=grid[r2][c2];grid[r2][c2]=t
	_draw();moves-=1;$MovesNum.text=str(moves)
	_check()

func _check():
	var m=[]
	for r in ROWS:
		var c=0
		while c<COLS:var t=grid[r][c];var e=c;while e<COLS and grid[r][e]==t:e+=1
		if e-c>=3:for cc in range(c,e):m.append(Vector2(cc,r));c=e
	for c in COLS:
		var r=0
		while r<ROWS:var t=grid[r][c];var e=r;while e<ROWS and grid[e][c]==t:e+=1
		if e-r>=3:for rr in range(r,e):m.append(Vector2(c,rr));r=e
	if m.size()>=3:
		var p={};for mm in m:p["%d,%d"%[mm.x,mm.y]]=true
		score+=p.size()*10
		$ScoreFill.offset_right=20+680*score/3000
		$ScoreText.text="%d / 3.000"%score
		for k in p:var cc=int(k.split(",")[0]);var rr=int(k.split(",")[1]);grid[rr][cc]=randi()%6
		await get_tree().create_timer(0.15).timeout;_draw()
		await get_tree().create_timer(0.1).timeout;_check()
	else:
		var t=grid[_r1][_c1];grid[_r1][_c1]=grid[_r2][_c2];grid[_r2][_c2]=t
		_draw();moves+=1;$MovesNum.text=str(moves)
	busy=false;sel=null
