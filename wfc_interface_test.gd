# InterfaceTest 
# Static output size
# rules: random 0-1
static func wfc_interface_test(w: int, h: int) -> Array[int]:
	var result: Array[int] = [];
	result.resize(w*h);
	result.fill(0);
	
	for i in w:
		for j in h:
			result[j*w+i] = i % 2;
			
	return result;
	
static var posibilityMap = [];
static var paternSize = Vector2(10,7);
static var patern: Array[int] = [
	1,1,1,0,0,0,0,0,0,0,
	1,2,1,0,0,0,0,0,0,0,
	1,1,1,0,4,0,0,0,0,0,
	0,0,0,0,4,0,0,0,0,0,
	0,3,3,0,4,0,0,1,2,0,
	0,3,3,0,4,0,0,3,4,0,
	0,0,0,0,0,0,0,0,0,0,
]
static var cardSize = Vector2(3,3);
static var cardRadius = Vector2(ceil(cardSize[0] / 2), ceil(cardSize[1] / 2));
static var deck;

static func init(size):
	deck = build_deck(patern, paternSize, cardSize);
	
	print('deck ', deck.size());
	for c in deck:
		print(c)
	
	posibilityMap.resize(size);
	posibilityMap.fill(deck.duplicate());
	
	
static func wfc_v1(w: int, h: int, data, onlyOneStep: bool) -> Array[int]:
	
	var result: Array[int] = data;
	
	var cardCenterIndex = floor(cardSize[0] / 2)*cardSize[0] + floor(cardSize[1] / 2);

	
	var steps = 1 if onlyOneStep else w*h;
	
	for _unused in steps:
		print('------------------------------  ', _unused);
		var minValueFields = get_min_posibility_fields(posibilityMap);
		
		print('minValueFields: ', minValueFields);
		
		# Field we will be filling
		var fieldIndex = minValueFields.pick_random();
		#var fieldIndex = minValueFields[0];
		
		if(fieldIndex == null):
			print('NULL!');
			continue;
		
		print('fieldIndex', fieldIndex);
		
		# Card we will be using
		var card = posibilityMap[fieldIndex].pick_random();
		#var card = posibilityMap[fieldIndex][0];
		
		
		print('CARD: ', card);
		
		var valueToSet = card[cardCenterIndex]
		
		
		print('PREV VALUE: ', result[fieldIndex]);
		print('SET ', fieldIndex, ' <=', valueToSet);
		
		result[fieldIndex] = valueToSet;
		posibilityMap[fieldIndex] = [];
		
		
		var fieldY = floor(fieldIndex / w);
		var fieldX = fieldIndex % w; 
		
		for x in range(-cardRadius[0]+1, cardRadius[0]):
			for y in range(-cardRadius[1]+1, cardRadius[1]):
				#print(x, ' | ', y);
				if x == 0 && y == 0:
					continue;
					
				if fieldX + x < 0 || fieldX + x >= w:
					continue;
					
				if fieldY + y < 0 || fieldY + y >= h:
					continue; 
					
				#print({
					#'fieldIndex': fieldIndex,
					#'fieldX': fieldX,
					#'fieldY': fieldY,
					#'x': x,
					#'y': y,
					#'w': w,
					#'h': h,
				#});
					
				var fieldIndexToReduce = fieldIndex+(y*w)+x;
				#print('fieldIndexToReduce: ', fieldIndexToReduce);
					
				var fieldToReduce: Array = posibilityMap[fieldIndexToReduce];
				
				#print('CHECKING: ', fieldIndexToReduce)
				#print('pre reduce ', posibilityMap[fieldIndexToReduce].size())
				
				var cardFieldIndex = (cardCenterIndex-(y*cardSize[0]))-x;
				#print('cardFieldIndex: ', cardFieldIndex);
				
				if (fieldToReduce.size() == 0):
					#print('validate: ', fieldIndexToReduce);
					var validCardIndex = (cardCenterIndex+(y*cardSize[0]))+x;
					#if card[validCardIndex ] != result[fieldIndexToReduce]:
						#print(card[validCardIndex ], ' ----- ', result[fieldIndexToReduce]);
				
				posibilityMap[fieldIndexToReduce] = fieldToReduce.filter(func(c): 
					var r = c[cardFieldIndex] == valueToSet;
					#if(r):
						#print('ALLOW:', c);
					return r
				);
				#print('post reduce #2: ', posibilityMap[fieldIndexToReduce].size())
		
	#print('result: ', result);
		
	return result;

static func get_min_posibility_fields(map: Array) -> Array[int]:
	var minValue = 999999;
	var result: Array[int] = [];
	
	var size = map.size();
	
	for i in size:
		var fieldPosibilitySize = map[i].size();
		
		if fieldPosibilitySize == 0:
			continue;
			
		if fieldPosibilitySize > minValue:
			continue;
			
		if fieldPosibilitySize == minValue:
			result.append(i);
			
		if fieldPosibilitySize < minValue:
			minValue = fieldPosibilitySize;
			result = [i];
			
	print('minValue: ', minValue)
	return result

static func build_deck(patern: Array[int], patternSize: Vector2, cardSize: Vector2):
	var result = [];
	
	# Iterujemy po kazdym polu w paternie
	for i in patternSize[0]:
		for j in patternSize[1]:
			
			var card = [];
			
			for x in range(-cardRadius[0]+1, cardRadius[0]):
				for y in range(-cardRadius[1]+1, cardRadius[1]):
					
					if (i + x < 0 || i + x >= patternSize[0]):
						#print('null x: ', i+x);
						card.append(null);
						continue;
					
					if (j + y < 0 || j + y >= patternSize[1]):
						#print('null y: ', j+y);
						card.append(null);
						continue;
						
					card.append(patern[(j+y)*patternSize[0] + i+x]);
					
			print(card);
			result.append(card);
		
	return result;
