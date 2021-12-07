export POETRY_VIRTUALENVS_IN_PROJECT = true

## Dependencies
init: PYTHON_VERSION ?= 3.9
init:
ifdef PYTHON_PATH
	poetry env use $(PYTHON_PATH)
else
	command -V python$(PYTHON_VERSION) < /dev/null
	poetry env use $(shell command -v python$(PYTHON_VERSION) < /dev/null)
endif

poetry.lock:
	poetry lock

deps:
	poetry install
	poetry run python -V

.PHONY: lint
lint:
	poetry check
	poetry run black --check --color --diff .
	poetry run flake8
	poetry run pylint docs/conf.py

build/html/index.html::
	poetry run sphinx-build -n -W docs $(@D)
	@echo Documentation available here: $@

.PHONY: docs build
docs build: build/html/index.html

live: build/html/index.html
	poetry run sphinx-autobuild --open-browser --delay=1 -n -W docs $(<D)

## Misc

clean:
	rm -rfv *.egg-info/ *cache*/ .*cache*/ .coverage coverage.xml htmlcov/ dist/ build/ requirements.txt
	find . -name __pycache__ -type d -exec rm -r {} +

distclean: clean
	rm -rf .venv/

