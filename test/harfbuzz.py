# -*- coding: utf-8 -*-

import unittest

from pyharfbuzz import *


class TestHarfbuzz(unittest.TestCase):
    font_name = 'Vazir.ttf'
    unshaped = "یک نوشته ی تستی"
    shaped = "ﯽﺘﺴﺗ ی ﻪﺘﺷﻮﻧ ﮏﯾ"

    def test_init(self):
        ft_library = FTLibrary()
        ft_library.init()

        ft_face = FTFace()
        ft_face.init(ft_library, self.font_name)

    def test_shape(self):
        out_put = shape(self.font_name, self.unshaped)
        shaped = ''.join([c['char'] for c in out_put])
        self.assertEqual(self.shaped, shaped)

    def test_buffer(self):
        hb_buffer = HBBufferT()
        hb_buffer.hb_buffer_add_utf8(self.unshaped, -1, 0, -1)
        hb_buffer2 = hb_buffer_reference(hb_buffer)


if __name__ == '__main__':
    unittest.main()