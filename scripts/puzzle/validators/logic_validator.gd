class_name LogicValidator
extends RefCounted

static func validate(user_input: Variant, puzzle_data: Dictionary) -> Dictionary:
	var expected_solution = puzzle_data.get("solution")
	var accepted_answers: Array = puzzle_data.get("accepted_answers", [])
	
	var user_clean = str(user_input).strip_edges().to_lower()
	var expected_clean = str(expected_solution).strip_edges().to_lower()
	
	# Comparação direta
	if user_clean == expected_clean:
		return {"is_correct": true, "diagnostic": ""}
	
	for acc in accepted_answers:
		if user_clean == str(acc).strip_edges().to_lower():
			return {"is_correct": true, "diagnostic": ""}
	
	# Verificação de erro comum
	var diagnostic_msg = _find_common_error(user_clean, puzzle_data.get("common_errors", []))
	if diagnostic_msg == "":
		diagnostic_msg = "A hipotese deduzida gera contradicoes com uma ou mais premissas fornecidas. Experimente testar as pistas isoladamente."
	
	return {"is_correct": false, "diagnostic": diagnostic_msg}

static func _find_common_error(input_str: String, common_errors: Array) -> String:
	for err in common_errors:
		var pattern = str(err.get("pattern", "")).strip_edges().to_lower()
		if pattern != "" and (input_str == pattern or input_str.contains(pattern)):
			return err.get("feedback", "")
	return ""
