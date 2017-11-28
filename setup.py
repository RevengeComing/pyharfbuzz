from sys import platform

from setuptools import Extension, setup

sources = ['pyharfbuzz/harfbuzz.c']
libraries = ['harfbuzz', 'freetype']

if platform == "linux" or platform == "linux2":
    include_dirs = ['/usr/include/harfbuzz/', '/usr/include/freetype2/']
    library_dirs = ['/usr/include']
elif platform == "darwin":
    library_dirs = ['/usr/local/include']
    include_dirs = ['/usr/local/include/harfbuzz', '/usr/local/include/freetype2']


setup(
    name='pyharfbuzz',
    version='0.1.1',
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