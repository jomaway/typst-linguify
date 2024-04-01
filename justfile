

[private]
default:
	just --list

run-tests:
	mkdir -p tests/results
	typst compile tests/assertion_tests.typ tests/results/test_assertions.pdf --root ..
	typst compile tests/fluent-test.typ tests/results/test_fluent.pdf --root ..

clean-tests:
	rm -r tests/results

build-docs:
	typst compile docs/docs.typ --root ..