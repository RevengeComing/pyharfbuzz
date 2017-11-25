from sys import platform

from setuptools import setup, Extension

libraries = ['freetype', 'harfbuzz']

if platform == "linux" or platform == "linux2":
    include_dirs = ['/usr/include/harfbuzz/', '/usr/include/freetype2/']
elif platform == "darwin":
    include_dirs = ['/usr/local/include/harfbuzz', '/usr/local/include/freetype2']

setup(
    name='pyharfbuzz',
    version='0.0.2',
    description='Python binding for harfbuzz an OpenType text shaping.',
    author='Sepehr Hamzehlouy',
    author_email='s.hamzelooy@gmail.com',
    license='MIT',
    packages=['pyharfbuzz'],
      ext_modules=[Extension(
            name='pyharfbuzz.harfbuzz',
            sources=['pyharfbuzz/harfbuzz.c'],
            libraries=libraries,
            include_dirs=include_dirs)
    ],
    include_package_data=True
)