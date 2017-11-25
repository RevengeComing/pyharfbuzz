from pyharfbuzz import FTLibrary, FTFace, HBFontT, HBBufferT, hb_shape


def main():
    my_text = 'این یک تست است.'

    # Initialize FreeType and create FreeType font face.
    ft_library = FTLibrary()
    ft_library.init()

    ft_face = FTFace()
    ft_face.init(ft_library, "Vazir.ttf")
    ft_face.set_charsize(36)

    # Create hb-ft font.
    hb_font = HBFontT()
    hb_font.hb_ft_font_create(ft_face)

    # Create hb-buffer and populate.
    hb_buffer_t = HBBufferT()
    hb_buffer_t.hb_buffer_add_utf8(my_text, -1, 0, -1)
    hb_buffer_t.hb_buffer_guess_segment_properties()

    # Shape it! 
    hb_shape(hb_font, hb_buffer_t, None, 0)

    # Get glyph information and positions out of the buffer.
    my_text_len = hb_buffer_t.get_length()

if __name__ == '__main__':
    main()