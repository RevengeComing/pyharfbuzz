from setuptools import setup, Extension

libraries = ['freetype', 'harfbuzz']
include_dirs = ['/usr/include/harfbuzz/', '/usr/include/freetype2/']

setup(
    name='pyharfbuzz',
    version='0.0.1',
    description='A collection of framework independent HTTP protocol utils.',
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