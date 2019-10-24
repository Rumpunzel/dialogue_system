extends Node


func vector_add_arrays(arrays:Array) -> Array:
	var return_array = []
	
	if not arrays.empty():
		var max_array_length = 0
		
		for array in arrays:
			max_array_length = max(array.size(), max_array_length)
		
		for i in range(max_array_length):
			var value = 0
			
			for array in arrays:
				if i < array.size():
					value += array[i]
			
			return_array.append(value)
	
	return return_array

func vector_add_dictionaries(dictionaries:Array) -> Dictionary:
	var return_dictionary:Dictionary = { }
	
	for dictionary in dictionaries:
		for key in dictionary.keys():
			return_dictionary[key] = return_dictionary.get(key, 0) + dictionary[key]
	
	return return_dictionary

func calculate_loop_modulo(index:int, array_size:int, loop_from:int) -> int:
	if index >= array_size and not array_size == 0:
		index = loop_from + (index % array_size) % (array_size - loop_from)
	
	return index

func get_unique_values_in_array(array:Array, stepify_value = 0):
	var unique_points = 0
	var already_checked_values:Array = []
	
	for value in array:
		if stepify_value > 0:
			match typeof(value):
				TYPE_REAL:
					value = stepify(value, stepify_value)
				TYPE_VECTOR2:
					value = Vector2(stepify(value.x, stepify_value), stepify(value.y, stepify_value))
		
		if not already_checked_values.has(value):
			unique_points += 1
			already_checked_values.append(value)
	
	return unique_points

func generate_array(length, content):
	var array:Array = [ ]
	
	for _i in range(length):
		array.append(content)
	
	return array
