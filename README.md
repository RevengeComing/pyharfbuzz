# Python binding for Harfbuzz an OpenType text shaping engine.


## Installation
```
pip install pyharfbuzz
```

Freetype and Harfbuzz is embedded inside pypi package so you dont need to install them on your machine.

-------------------

It is working on Ubuntu(Py23) and Mac(Py3).
Windows support amd Mac(Py2) is on progress.

-------------------

At this moment its width calculation is being used inside [kivy-i18n](https://github.com/RevengeComing/kivy-i18n)

-------------------

Use shape function to shape a text:

```
from pyharfbuzz import shape

your_shaped_text_info = shape('Vazir.ttf', 'your text')
```

To use lower level APIs see example.py.