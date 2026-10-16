class_name MathValidator
extends RefCounted

static func validate(user_input: Variant, puzzle_data: Dictionary) -> Dictionary:
	var puzzle_id = puzzle_data.get("id", "")
	var accepted_answers: Array = puzzle_data.get("accepted_answers", [])
	
	# Caso Especial: Investigação 1 — Tisana Botânica (PUZ_MATH_001)
	if puzzle_id == "PUZ_MATH_001":
		return _validate_tisana(user_input, puzzle_data)
	
	# Caso Geral de MULTI_FIELD
	if user_input is Dictionary:
		return _validate_generic_multi_field(user_input, puzzle_data)
	
	# Caso: Resposta em Array
	if user_input is Array:
		var expected = puzzle_data.get("solution")
		if expected is Array and user_input.size() == expected.size():
			var match_all = true
			for i in range(expected.size()):
				if not _is_close(float(user_input[i]), float(expected[i])):
					match_all = false
					break
			if match_all:
				return {"is_correct": true, "diagnostic": ""}
	
	# Caso: Número único
	var numeric_input = _parse_number(user_input)
	if numeric_input != null:
		var target_num = _parse_number(puzzle_data.get("solution"))
		if target_num != null and _is_close(numeric_input, target_num):
			return {"is_correct": true, "diagnostic": ""}
	
	# Caso: String exata em accepted_answers
	var raw_str = str(user_input).strip_edges().to_lower()
	for acc in accepted_answers:
		if _clean_str(raw_str) == _clean_str(str(acc)):
			return {"is_correct": true, "diagnostic": ""}
	
	# Diagnóstico de erros comuns cadastrados
	var diagnostic_msg = _find_common_error(raw_str, puzzle_data.get("common_errors", []))
	if diagnostic_msg == "":
		diagnostic_msg = "O valor calculado difere do esperado. Releia os dados fornecidos no enunciado e confira cada etapa da sua operação matemática."
	
	return {"is_correct": false, "diagnostic": diagnostic_msg}

static func _validate_tisana(user_input: Variant, _puzzle_data: Dictionary) -> Dictionary:
	var leaves = -1.0
	var drops = -1.0
	
	if user_input is Dictionary:
		leaves = _parse_number(user_input.get("leaves", user_input.get("folhas", -1)))
		drops = _parse_number(user_input.get("drops", user_input.get("gotas", -1)))
	elif user_input is Array and user_input.size() >= 2:
		leaves = _parse_number(user_input[0])
		drops = _parse_number(user_input[1])
	else:
		# Extrai números de string como "12, 18" ou "12 folhas e 18 gotas"
		var nums = _extract_all_numbers(str(user_input))
		if nums.size() >= 2:
			leaves = nums[0]
			drops = nums[1]
	
	if leaves == 12.0 and drops == 18.0:
		return {"is_correct": true, "diagnostic": ""}
	
	# Feedback diagnóstico parcial detalhado
	if leaves == 12.0 and drops != 18.0:
		return {
			"is_correct": false,
			"diagnostic": "Você acertou as folhas de anis (12 folhas)! No entanto, revise as gotas de óleo de linho: para 1 dose são 6 gotas; quantas gotas serão necessárias para 3 doses completas?"
		}
	
	if leaves != 12.0 and drops == 18.0:
		return {
			"is_correct": false,
			"diagnostic": "Você acertou as gotas de óleo de linho (18 gotas)! No entanto, confira as folhas de anis: para 1 dose são 4 folhas; quantas folhas serão necessárias para 3 doses completas?"
		}
	
	if (leaves == 7.0 and drops == 9.0) or (leaves == 4.0 + 3.0 and drops == 6.0 + 3.0):
		return {
			"is_correct": false,
			"diagnostic": "Atenção à proporção: para triplicar a receita (3 doses), cada ingrediente deve ser multiplicado por 3 (4 × 3 e 6 × 3), e não somado a 3."
		}
	
	return {
		"is_correct": false,
		"diagnostic": "Multiplique a quantidade de cada ingrediente pelo número de doses desejadas (3). Lembre-se: são 4 folhas e 6 gotas por dose."
	}

static func _validate_generic_multi_field(user_dict: Dictionary, puzzle_data: Dictionary) -> Dictionary:
	var fields: Array = puzzle_data.get("fields", [])
	if fields.is_empty():
		return {"is_correct": false, "diagnostic": "Formato de campos não reconhecido."}
	
	var all_correct = true
	var correct_count = 0
	var first_error_field = ""
	
	for f in fields:
		var f_id = f.get("id", "")
		var expected = _parse_number(f.get("expected"))
		var user_val = _parse_number(user_dict.get(f_id))
		
		if user_val != null and expected != null and _is_close(user_val, expected):
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
			"diagnostic": "Você acertou parte dos valores! Confira atentamente o cálculo para o campo: %s." % first_error_field
		}
	
	return {
		"is_correct": false,
		"diagnostic": "Os valores inseridos não correspondem às relações do problema. Revise os dados e tente novamente."
	}

static func _clean_str(s: String) -> String:
	return s.strip_edges().to_lower().replace(" ", "").replace("folhas", "").replace("gotas", "").replace("de", "").replace("e", "").replace(";", ",").replace("`", "")

static func _parse_number(val: Variant) -> Variant:
	if val == null:
		return null
	if val is int or val is float:
		return float(val)
	var s = str(val).strip_edges().replace(",", ".")
	if s.is_valid_float():
		return s.to_float()
	return null

static func _extract_all_numbers(s: String) -> Array[float]:
	var clean = s.strip_edges().replace(",", ".")
	var regex = RegEx.new()
	regex.compile("[-+]?[0-9]*\\.?[0-9]+")
	var matches = regex.search_all(clean)
	var results: Array[float] = []
	for m in matches:
		var v = m.get_string().to_float()
		results.append(v)
	return results

static func _is_close(a: float, b: float, epsilon: float = 0.01) -> bool:
	return abs(a - b) <= epsilon

static func _find_common_error(input_str: String, common_errors: Array) -> String:
	var clean_input = _clean_str(input_str)
	for err in common_errors:
		var pattern = _clean_str(str(err.get("pattern", "")))
		if pattern != "" and (clean_input == pattern or clean_input.contains(pattern)):
			return err.get("feedback", "")
	return ""
