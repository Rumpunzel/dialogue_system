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

func vector_add_dictionaries(dictionaries:Array, main_dictionary = 0) -> Dictionary:
	var return_dictionary = { }
	
	if not dictionaries.empty():
		for key in dictionaries[main_dictionary]:
			var value = 0
			
			for dictionary in dictionaries:
				value += dictionary.get(key, 0)
			
			return_dictionary[key] = value
	
	return return_dictionary

func calculate_loop_modulo(index:int, array_size:int, loop_from:int) -> int:
	if index >= array_size:
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
