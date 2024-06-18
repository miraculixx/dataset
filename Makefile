
all: clean test dists

.PHONY: test
test:
	pytest -v -x

test-postgres:
	-docker rm --force postgres
	docker run --name postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=dataset -d -p 5432:5432 postgres
	export DATABASE_URL="postgresql://postgres:postgres@localhost:5432/dataset"; sleep 5; pytest -v -k "test_dataset"
	killall make

dbs:
	gh act

dists:
	python setup.py sdist
	python setup.py bdist_wheel

release: dists
	pip install -q twine
	twine upload dist/*

.PHONY: clean
clean:
	rm -rf dist build .eggs
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
