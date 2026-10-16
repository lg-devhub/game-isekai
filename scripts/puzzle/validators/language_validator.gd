class_name LanguageValidator
extends RefCounted

static func validate(user_input: Variant, puzzle_data: Dictionary) -> Dictionary:
	var expected_solution = puzzle_data.get("solution")
	var accepted_answers: Array = puzzle_data.get("accepted_answers", [])
	
	var user_norm = _normalize(str(user_input))
	var expected_norm = _normalize(str(expected_solution))
	
	if user_norm == expected_norm:
		return {"is_correct": true, "diagnostic": ""}
	
	for acc in accepted_answers:
		if user_norm == _normalize(str(acc)):
			return {"is_correct": true, "diagnostic": ""}
	
	# Verifica se resposta numérica é esperada (como no manifesto PUZ_LANG_001)
	var user_num = _extract_number(str(user_input))
	var target_num = _extract_number(str(expected_solution))
	if user_num != null and target_num != null and user_num == target_num:
		return {"is_correct": true, "diagnostic": ""}
	
	# Verifica se opção inicia com a letra da alternativa (ex: "A", "Opção A")
	if expected_norm.begins_with("a") and (user_norm == "a" or user_norm == "opcaoa"):
		return {"is_correct": true, "diagnostic": ""}
	if expected_norm.begins_with("b") and (user_norm == "b" or user_norm == "opcaob"):
		return {"is_correct": true, "diagnostic": ""}
	if expected_norm.begins_with("c") and (user_norm == "c" or user_norm == "opcaoc"):
		return {"is_correct": true, "diagnostic": ""}
	if expected_norm.begins_with("d") and (user_norm == "d" or user_norm == "opcaod"):
		return {"is_correct": true, "diagnostic": ""}
	
	# Diagnóstico de erros comuns
	var diagnostic_msg = _find_common_error(user_norm, puzzle_data.get("common_errors", []))
	if diagnostic_msg == "":
		diagnostic_msg = "Sua interpretação difere das evidências textuais apresentadas no documento. Releia o trecho com atenção especial aos termos explícitos e ao contexto."
	
	return {"is_correct": false, "diagnostic": diagnostic_msg}

static func _normalize(s: String) -> String:
	var clean = s.strip_edges().to_lower()
	clean = clean.replace("á", "a").replace("à", "a").replace("ã", "a").replace("â", "a")
	clean = clean.replace("é", "e").replace("ê", "e")
	clean = clean.replace("í", "i")
	clean = clean.replace("ó", "o").replace("õ", "o").replace("ô", "o")
	clean = clean.replace("ú", "u")
	clean = clean.replace("ç", "c")
	clean = clean.replace(".", "").replace(",", "").replace("-", "").replace(" ", "").replace("`", "")
	return clean

static func _extract_number(s: String) -> Variant:
	var regex = RegEx.new()
	regex.compile("[0-9]+")
	var m = regex.search(s)
	if m:
		return m.get_string().to_int()
	return null

static func _find_common_error(input_str: String, common_errors: Array) -> String:
	for err in common_errors:
		var pattern = _normalize(str(err.get("pattern", "")))
		if pattern != "" and (input_str == pattern or input_str.contains(pattern)):
			return err.get("feedback", "")
	return ""
