extends Node2D

const wfc = preload("res://wfc_interface_test.gd");

var centerpoS: Vector2 = Vector2(0,0);
var mapW: int = 50;
var mapH: int = 50;
var tileSize: int = 10;

var data: Array[int] = [];



# Called when the node enters the scene tree for the first time.
func _ready():
	data.resize(mapW*mapH);
	data.fill(-1);
	
	#TODO: MOVE THIS!
	wfc.init(mapW*mapH);
	
	#data = wfc.wfc_interface_test(mapW,mapH);
	#data = wfc.wfc_v1(mapW,mapH, data, false);
	
	startInterval();
	
	#printDeck();
	
	pass # Replace with function body.

func _draw():
	#print('data size: ', data.size());
	#print('data:   ', data);
	
	for j in mapH:
		for i in mapW:
			var color = Color(1,.8,.8);
			var index = j*mapW+i;
			var v = data[index];
			
			#print('index: ', index);
				
			if v == 0:
				color = Color(1,1,1);
			
			if v == 1:
				color = Color(0,0,0);
			
			if v == 2:
				color = Color(1,0,0);
			
			if v == 3:
				color = Color(0,1,0);
			if v == 4:
				color = Color(0,0,1);
				
			#print(index, ' | ', i, ' ', j, ' ', v, ' ', color);
				
			draw_rect(Rect2(i*tileSize, j*tileSize, tileSize, tileSize), color, true);
			
func nextStep():
	data = wfc.wfc_v1(mapW,mapH, data, true);
	queue_redraw();

func startInterval():
	var _timer = Timer.new();
	add_child(_timer)

	_timer.connect("timeout", nextStep)
	_timer.set_wait_time(0.05)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()

func _input(event):
	if (event.is_pressed()): 
		nextStep()
