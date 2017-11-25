.PHONY: compile clean


compile:
	cython pyharfbuzz/harfbuzz.pyx
	python setup.py build_ext --inplace


install: compile
	python setup.py install