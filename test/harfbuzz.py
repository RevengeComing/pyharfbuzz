# -*- coding: utf-8 -*-

import unittest

from pyharfbuzz import *


class TestHarfbuzz(unittest.TestCase):
    font_name = 'Vazir.ttf'
    unshaped = "یک نوشته ی تستی"
    shaped = "ﯽﺘﺴﺗ ی ﻪﺘﺷﻮﻧ ﮏﯾ"

    dir_rtl = "تست rtl تست"
    dir_ltr = "ltr تست ltr"

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

    def test_directions(self):
        ft_library = FTLibrary()
        ft_library.init()

        ft_face = FTFace()
        ft_face.init(ft_library, self.font_name)
        ft_face.set_charsize(32*64)

        hb_font = HBFontT()
        hb_font.hb_ft_font_create(ft_face)

        hb_buffer_t = HBBufferT()
        hb_buffer_t.hb_buffer_add_utf8(self.dir_ltr, -1, 0, -1)
        hb_buffer_t.guess_segment_properties()

        hb_shape(hb_font, hb_buffer_t, None, 0)

        self.assertTrue(is_ltr(hb_buffer_t))

        hb_buffer_t2 = HBBufferT()
        hb_buffer_t2.hb_buffer_add_utf8(self.dir_rtl, -1, 0, -1)
        hb_buffer_t2.guess_segment_properties()

        hb_shape(hb_font, hb_buffer_t2, None, 0)

        self.assertTrue(is_rtl(hb_buffer_t2))


if __name__ == '__main__':
    unittest.main()