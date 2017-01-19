## Makefile

.PHONY: test

test:
	bats functions/*.bats
	bats functions/utils/*.bats
	bats functions/*.bats > test.tap
	bats functions/utils/*.bats > test.tap