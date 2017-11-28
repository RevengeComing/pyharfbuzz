import sys

from pyharfbuzz import FTLibrary, FTFace, HBFontT, HBBufferT, hb_shape, get_glyph_name,\
    hb_buffer_get_direction, is_horizontal


def main(*args):
    if len(args) != 3:
        print("usage: python example.py font-file.ttf text")
        sys.exit(1)

    font_file = args[1]
    my_text = args[2]

    # Initialize FreeType and create FreeType font face.
    ft_library = FTLibrary()
    ft_library.init()

    ft_face = FTFace()
    ft_face.init(ft_library, font_file)
    ft_face.set_charsize(36*64)

    # Create hb-ft font.
    hb_font = HBFontT()
    hb_font.hb_ft_font_create(ft_face)

    # Create hb-buffer and populate.
    hb_buffer_t = HBBufferT()
    hb_buffer_t.hb_buffer_add_utf8(my_text, -1, 0, -1)
    hb_buffer_t.guess_segment_properties()

    # Shape it! 
    hb_shape(hb_font, hb_buffer_t, None, 0)

    # Get glyph information and positions out of the buffer.
    my_text_len = hb_buffer_t.get_length()
    info = hb_buffer_t.get_glyph_infos()
    pos = hb_buffer_t.get_glyph_position()

    # Print them out as is.
    print("Raw buffer contents:")
    for i in range(my_text_len):
        gid = info[i]['codepoint']
        cluster = info[i]['cluster']
        x_advance = pos[i]['x_advance'] / 64
        y_advance = pos[i]['y_advance'] / 64
        x_offset = pos[i]['x_offset'] / 64
        y_offset = pos[i]['y_offset'] / 64

        glyph_name = get_glyph_name(hb_font, gid)

        print("glyph='%s'\tcluster=%d\tadvance=(%g,%g)\toffset=(%g,%g)" % (
                glyph_name.decode(),
                cluster,
                x_advance,
                y_advance,
                x_offset,
                y_offset,
            )
        )

    current_x = 0.0
    current_y = 0.0
    print("Converted to absolute positions:")
    for i in range(my_text_len):
        gid = info[i]['codepoint']
        cluster = info[i]['cluster']
        x_position = current_x + pos[i]['x_offset'] / 64
        y_position = current_y + pos[i]['y_offset'] / 64

        glyph_name = get_glyph_name(hb_font, gid)
        print("glyph='%s'\tcluster=%d\tposition=(%g,%g)" %
            (glyph_name.decode(), cluster, x_position, y_position)
        )

        current_x += pos[i]['x_advance'] / 64
        current_y += pos[i]['y_advance'] / 64

    print(is_horizontal(hb_buffer_get_direction(hb_buffer_t)))


if __name__ == '__main__':
    main(*sys.argv)