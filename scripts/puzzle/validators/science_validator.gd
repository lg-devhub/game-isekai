class_name ScienceValidator
extends RefCounted

static func validate(user_input: Variant, puzzle_data: Dictionary) -> Dictionary:
	var expected_solution = puzzle_data.get("solution")
	var accepted_answers: Array = puzzle_data.get("accepted_answers", [])
	
	# Caso MULTI_FIELD
	if user_input is Dictionary:
		return _validate_multi_field(user_input, puzzle_data)
	
	var user_clean = _clean_str(str(user_input))
	var expected_clean = _clean_str(str(expected_solution))
	
	if user_clean == expected_clean:
		return {"is_correct": true, "diagnostic": ""}
	
	for acc in accepted_answers:
		if user_clean == _clean_str(str(acc)):
			return {"is_correct": true, "diagnostic": ""}
	
	# Extração numérica pura se for grandeza física
	var user_num = _extract_first_number(str(user_input))
	var target_num = _extract_first_number(str(expected_solution))
	if user_num != null and target_num != null:
		if abs(user_num - target_num) <= 0.05:
			return {"is_correct": true, "diagnostic": ""}
	
	# Diagnóstico de erros comuns cadastrados
	var diagnostic_msg = _find_common_error(user_clean, puzzle_data.get("common_errors", []))
	if diagnostic_msg == "":
		diagnostic_msg = "O valor ou conclusão difere do esperado pelo fenômeno físico/científico. Revise as grandezas e tente novamente."
	
	return {"is_correct": false, "diagnostic": diagnostic_msg}

static func _validate_multi_field(user_dict: Dictionary, puzzle_data: Dictionary) -> Dictionary:
	var fields: Array = puzzle_data.get("fields", [])
	if fields.is_empty():
		return {"is_correct": false, "diagnostic": "Formato de campos não reconhecido."}
	
	var all_correct = true
	var correct_count = 0
	var first_error_field = ""
	
	for f in fields:
		var f_id = f.get("id", "")
		var expected = _extract_first_number(str(f.get("expected")))
		var user_val = _extract_first_number(str(user_dict.get(f_id, "")))
		
		if user_val != null and expected != null and abs(user_val - expected) <= 0.05:
			correct_count += 1
		else:
			all_correct = false
			if first_error_field.is_empty():
				first_error_field = f.get("label", f_id)
	
	if all_correct:
		return {"is_correct": true, "diagnostic": ""}
	
	if correct_count > 0:
		return {
			"is_correct": false,
			"diagnostic": "Você calculou corretamente parte dos valores! Confira atentamente o cálculo para o campo: %s." % first_error_field
		}
	
	return {
		"is_correct": false,
		"diagnostic": "Os valores inseridos não correspondem ao equilíbrio esperado. Revise os cálculos e unidades."
	}

static func _clean_str(s: String) -> String:
	return s.strip_edges().to_lower().replace(" ", "").replace("newtons", "n").replace("joules", "j").replace("metros", "m").replace("`", "").replace(".", "").replace(",", ".")

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
