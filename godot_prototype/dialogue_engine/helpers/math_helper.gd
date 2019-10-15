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
