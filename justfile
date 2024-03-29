

[private]
default:
	just --list

run-tests:
	typst compile tests/assertion_tests.typ test_result.pdf
