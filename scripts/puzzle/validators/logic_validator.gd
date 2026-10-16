class_name LogicValidator
extends RefCounted

static func validate(user_input: Variant, puzzle_data: Dictionary) -> Dictionary:
	var expected_solution = puzzle_data.get("solution")
	var accepted_answers: Array = puzzle_data.get("accepted_answers", [])
	
	var user_clean = _clean_str(str(user_input))
	var expected_clean = _clean_str(str(expected_solution))
	
	# Comparação direta
	if user_clean == expected_clean:
		return {"is_correct": true, "diagnostic": ""}
	
	for acc in accepted_answers:
		if user_clean == _clean_str(str(acc)):
			return {"is_correct": true, "diagnostic": ""}
	
	# Verificação de erro comum
	var diagnostic_msg = _find_common_error(user_clean, puzzle_data.get("common_errors", []))
	if diagnostic_msg == "":
		diagnostic_msg = "Essa dedução entra em contradição com uma das pistas apresentadas. Teste cada premissa individualmente e elimine as opções incompatíveis."
	
	return {"is_correct": false, "diagnostic": diagnostic_msg}

static func _clean_str(s: String) -> String:
	return s.strip_edges().to_lower().replace(" ", "").replace(".", "").replace(",", "").replace("-", "").replace("`", "")

static func _find_common_error(input_str: String, common_errors: Array) -> String:
	for err in common_errors:
		var pattern = _clean_str(str(err.get("pattern", "")))
		if pattern != "" and (input_str == pattern or input_str.contains(pattern)):
			return err.get("feedback", "")
	return ""
