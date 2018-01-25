from sys import platform

from setuptools import Extension, setup

sources = ['pyharfbuzz/harfbuzz.c']
libraries = ['harfbuzz', 'freetype']
library_dirs = ['freetype2/src', 'harfbuzz/src']
include_dirs = ['harfbuzz/src', 'freetype2/include']

setup(
    name='pyharfbuzz',
    version='0.2.0',
    description='Python binding for harfbuzz an OpenType text shaping.',
    author='Sepehr Hamzehlouy',
    author_email='s.hamzelooy@gmail.com',
    license='MIT',
    url='https://github.com/RevengeComing/pyharfbuzz',
    packages=['pyharfbuzz'],
    ext_modules=[Extension(
        name='pyharfbuzz.harfbuzz',
        sources=sources,
        libraries=libraries,
        library_dirs=library_dirs,
        include_dirs=include_dirs)
    ],
    include_package_data=True
)