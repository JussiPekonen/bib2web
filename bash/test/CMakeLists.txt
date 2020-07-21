add_custom_target(bash-test)
add_custom_command(
	TARGET bash-test
	COMMAND shunit2)