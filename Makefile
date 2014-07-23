SHELL := /usr/bin/env bash

watch:
	watchmedo shell-command \
		--patterns="*.rst" \
		--ignore-pattern='_build/*' \
		--recursive \
		--command='make docs'

docs:
	$(MAKE) -C docs html

clean:
	$(MAKE) -C docs clean

.PHONY: docs watch clean
