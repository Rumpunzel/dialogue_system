extends Node


func vector_add_arrays(arrays:Array):
	var return_array = []
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
