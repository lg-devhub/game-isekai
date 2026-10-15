class_name MathValidator
extends RefCounted

static func validate(user_input: Variant, puzzle_data: Dictionary) -> Dictionary:
	var expected_solution = puzzle_data.get("solution")
	var accepted_answers: Array = puzzle_data.get("accepted_answers", [])
	
	# Caso 1: Array com múltiplos valores (ex: Folhas e Gotas)
	if expected_solution is Array or typeof(expected_solution) == TYPE_ARRAY:
		if user_input is Array:
			if user_input.size() == expected_solution.size():
				var all_match = true
				for i in range(expected_solution.size()):
					if not _is_close(float(user_input[i]), float(expected_solution[i])):
						all_match = false
						break
				if all_match:
					return {"is_correct": true, "diagnostic": ""}
		
		# Verificação de string com vírgula (ex: "12, 18")
		var input_str = str(user_input).strip_edges()
		for acc in accepted_answers:
			if input_str.to_lower() == str(acc).to_lower().strip_edges():
				return {"is_correct": true, "diagnostic": ""}
	
	# Caso 2: Número único
	var numeric_input = _parse_number(user_input)
	if numeric_input != null:
		var target_num = _parse_number(expected_solution)
		if target_num != null and _is_close(numeric_input, target_num):
			return {"is_correct": true, "diagnostic": ""}
	
	# Caso 3: String de resposta alternativa
	var raw_str = str(user_input).strip_edges().to_lower()
	for acc in accepted_answers:
		if raw_str == str(acc).strip_edges().to_lower():
			return {"is_correct": true, "diagnostic": ""}
	
	# Diagnóstico de erro comum cadastrado
	var diagnostic_msg = _find_common_error(raw_str, puzzle_data.get("common_errors", []))
	if diagnostic_msg == "":
		diagnostic_msg = "O resultado numerico nao corresponde a proporcao ou equacao calculada. Revise as etapas e relacione os dados do enunciado."
	
	return {"is_correct": false, "diagnostic": diagnostic_msg}

static func _parse_number(val: Variant) -> Variant:
	if val is int or val is float:
		return float(val)
	var s = str(val).strip_edges().replace(",", ".")
	if s.is_valid_float():
		return s.to_float()
	return null

static func _is_close(a: float, b: float, epsilon: float = 0.001) -> bool:
	return abs(a - b) <= epsilon

static func _find_common_error(input_str: String, common_errors: Array) -> String:
	for err in common_errors:
		var pattern = str(err.get("pattern", "")).strip_edges().to_lower()
		if pattern != "" and (input_str == pattern or input_str.contains(pattern)):
			return err.get("feedback", "")
	return ""
