.PHONY: compile clean run_tests


run_tests:
	python test/harfbuzz.py


compile:
	cython pyharfbuzz/harfbuzz.pyx
	python setup.py build_ext --inplace


install: compile
	python setup.py install