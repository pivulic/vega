## Makefile

.PHONY: test

test:
	bats functions/*.bats
	bats functions/*.bats > test.tap