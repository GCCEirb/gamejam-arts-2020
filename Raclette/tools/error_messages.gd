class_name ErrorMessages

enum Warning {
	SHOULD_NOT_BE_EMPTY
}
const MESSAGES: = {
	Warning.SHOULD_NOT_BE_EMPTY:" should not be empty"
}


static func get_message(prefix: String, code: int) -> String:
	return prefix + MESSAGES[code]
