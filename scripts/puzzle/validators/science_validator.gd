class_name ScienceValidator
extends RefCounted

static func validate(user_input: Variant, puzzle_data: Dictionary) -> Dictionary:
	var expected_solution = puzzle_data.get("solution")
	var accepted_answers: Array = puzzle_data.get("accepted_answers", [])
	
	var user_clean = _clean_str(str(user_input))
	var expected_clean = _clean_str(str(expected_solution))
	
	if user_clean == expected_clean:
		return {"is_correct": true, "diagnostic": ""}
	
	for acc in accepted_answers:
		if user_clean == _clean_str(str(acc)):
			return {"is_correct": true, "diagnostic": ""}
	
	# Extração numérica pura se for valor físico
	var user_num = _extract_first_number(str(user_input))
	var target_num = _extract_first_number(str(expected_solution))
	if user_num != null and target_num != null:
		if abs(user_num - target_num) <= 0.01:
			return {"is_correct": true, "diagnostic": ""}
	
	var diagnostic_msg = _find_common_error(user_clean, puzzle_data.get("common_errors", []))
	if diagnostic_msg == "":
		diagnostic_msg = "A conclusao cientifica ou calculo fisico/quimico difere da lei natural aplicavel. Revise as variaveis e unidades de medida envolvidas."
	
	return {"is_correct": false, "diagnostic": diagnostic_msg}

static func _clean_str(s: String) -> String:
	return s.strip_edges().to_lower().replace(" ", "").replace("newtons", "n").replace("joules", "j").replace("metros", "m")

static func _extract_first_number(s: String) -> Variant:
	var clean = s.strip_edges().replace(",", ".")
	var regex = RegEx.new()
	regex.compile("[-+]?[0-9]*\\.?[0-9]+")
	var match_result = regex.search(clean)
	if match_result:
		return match_result.get_string().to_float()
	return null

static func _find_common_error(input_str: String, common_errors: Array) -> String:
	for err in common_errors:
		var pattern = _clean_str(str(err.get("pattern", "")))
		if pattern != "" and (input_str == pattern or input_str.contains(pattern)):
			return err.get("feedback", "")
	return ""
