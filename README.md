# Python binding for Harfbuzz an OpenType text shaping engine.


## Installation
First you need to install freetype2 and harfbuzz. then You can install pyharfbuzz using pip:
```
pip install pyharfbuzz
```

## Usage
Use shape function to shape your text text:
```
from pyharfbuzz import shape

your_shaped_text_info = shape('Vazir.ttf', 'your text')
```

To use lower level APIs see example.py.

Open an issue if you need any harfbuzz API that pyharfbuzz doesn't support.
