.PHONY: compile clean run_tests upload


run_tests:
	python3 test/harfbuzz.py
	python2 test/harfbuzz.py


compile:
	cython pyharfbuzz/harfbuzz.pyx
	python setup.py build_ext --inplace
	python setup.py sdist


install: compile
	python setup.py install


upload:
	python setup.py sdist upload -r pypi


clean:
	rm -rf dist build pyharfbuzz.egg-info