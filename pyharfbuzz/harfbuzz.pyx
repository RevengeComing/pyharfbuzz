from . cimport charfbuzz
from .glyph import glyph_table

from ._compat import prepare_string, chr

__all__ = [
    'FTLibrary',
    'FTFace',
    'HBFontT',
    'HBBufferT',
    'hb_shape',
    'get_glyph_name', 'glyph_to_string',
    'hb_buffer_get_direction',
    'is_horizontal',
    'is_ltr', 'is_rtl', 'is_ttb', 'is_btt',
    'is_uni', 'get_char_by_glyph_name',
    'shape'
]

cdef class FTLibrary:
    cdef charfbuzz.FT_Library ft_library
    def init(self):
        error = charfbuzz.FT_Init_FreeType(&self.ft_library)
        if error:
            raise Exception("Freetype library cant be initilized.")


cdef class FTFace:
    cdef charfbuzz.FT_Face ft_face
    cdef const char* cfont_name
    def init(self, FTLibrary ftl, font_name):
        font_name = prepare_string(font_name)
        self.cfont_name = font_name

        error = charfbuzz.FT_New_Face(ftl.ft_library, self.cfont_name, 0, &self.ft_face)
        if error:
            raise Exception("Freetype face cant be initilized.")

    def set_charsize(self, char_size):
        error = charfbuzz.FT_Set_Char_Size(self.ft_face, char_size, char_size, 0, 0)
        if error:
            raise Exception("Freetype cant set char size initilized.")


cdef class HBFontT:
    cdef charfbuzz.hb_font_t *hb_font_t
    def hb_ft_font_create(self, FTFace ftf):
        self.hb_font_t = charfbuzz.hb_ft_font_create(ftf.ft_face, NULL)

    def __dealloc__(self):
        charfbuzz.hb_font_destroy(self.hb_font_t)


cdef class HBBufferT:
    cdef charfbuzz.hb_buffer_t *hb_buffer_t

    def __cinit__(self):
        self.hb_buffer_create()

    def hb_buffer_create(self):
        self.hb_buffer_t = charfbuzz.hb_buffer_create()

    def hb_buffer_add_utf8(self, text, text_length, item_offset, item_length):
        text = prepare_string(text)

        cdef const char *ctext = text
        cdef int ctext_length = text_length

        charfbuzz.hb_buffer_add_utf8(self.hb_buffer_t, ctext,
            ctext_length, item_offset, item_length)

    def guess_segment_properties(self):
        charfbuzz.hb_buffer_guess_segment_properties(self.hb_buffer_t)

    def get_length(self):
        return charfbuzz.hb_buffer_get_length(self.hb_buffer_t)

    def get_glyph_infos(self):
        glyph_info = HBGlyphInfoT()
        glyph_info.set_hb_glyph_info(self.hb_buffer_t)
        return glyph_info

    def get_glyph_position(self):
        glyph_position = HBGlyphPositionT()
        glyph_position.set_hb_glyph_positions(self.hb_buffer_t)
        return glyph_position

    def get_settings(self):
        cdef charfbuzz.hb_script_t script
        cdef charfbuzz.hb_language_t lang

        script = charfbuzz.hb_buffer_get_script(self.hb_buffer_t)
        lang = charfbuzz.hb_buffer_get_language(self.hb_buffer_t)
        return {'script' : script, 'language' : charfbuzz.hb_language_to_string(lang)}

    def __dealloc__(self):
        charfbuzz.hb_buffer_destroy(self.hb_buffer_t)


cdef class HBFeatureT:
    cdef charfbuzz.hb_feature_t *hb_feature_t


cdef class HBGlyphInfoT:
    cdef charfbuzz.hb_glyph_info_t *hb_glyph_info_t
    cdef set_hb_glyph_info(self, charfbuzz.hb_buffer_t * buffer):
        cdef charfbuzz.hb_glyph_info_t *hb_glyph_info_t = charfbuzz.hb_buffer_get_glyph_infos(buffer, NULL)
        self.hb_glyph_info_t = hb_glyph_info_t

    def __getitem__(self, x):
        return self.hb_glyph_info_t[x]


cdef class HBGlyphPositionT:
    cdef charfbuzz.hb_glyph_position_t *hb_glyph_position_t
    cdef set_hb_glyph_positions(self, charfbuzz.hb_buffer_t * buffer):
        cdef charfbuzz.hb_glyph_position_t *hb_glyph_position_t = charfbuzz.hb_buffer_get_glyph_positions(buffer, NULL)
        self.hb_glyph_position_t = hb_glyph_position_t

    def __getitem__(self, x):
        return self.hb_glyph_position_t[x]


def hb_shape(HBFontT font, HBBufferT buffer, HBFeatureT feature, num_features):
    charfbuzz.hb_shape(font.hb_font_t, buffer.hb_buffer_t, feature.hb_feature_t, num_features)

def get_glyph_name(HBFontT font, codepoint):
    cdef char glyph_name[32]
    charfbuzz.hb_font_get_glyph_name(font.hb_font_t, codepoint, glyph_name, sizeof(glyph_name))
    return glyph_name

def glyph_to_string(HBFontT font, codepoint):
    cdef char string[32]
    charfbuzz.hb_font_get_glyph_name(font.hb_font_t, codepoint, string, sizeof(string))
    return string

def hb_buffer_get_direction(HBBufferT buffer):
    return charfbuzz.hb_buffer_get_direction(buffer.hb_buffer_t)

def is_ltr(HBBufferT buffer):
    if hb_buffer_get_direction(buffer) == 4:
        return True
    return False

def is_rtl(HBBufferT buffer):
    if hb_buffer_get_direction(buffer) == 5:
        return True
    return False

def is_ttb(HBBufferT buffer):
    if hb_buffer_get_direction(buffer) == 6:
        return True
    return False

def is_btt(HBBufferT buffer):
    if hb_buffer_get_direction(buffer) == 7:
        return True
    return False

def is_horizontal(dir_code):
    if (dir_code == 4 or dir_code == 5):
        return True
    return False

def is_uni(glyph_name):
    if glyph_name in glyph_table:
        return False
    return True

def get_char_by_glyph_name(glyph_name):
    if is_uni(glyph_name):
        return chr(int(glyph_name[3:], 16))
    return glyph_table[glyph_name]

def shape(font_file, string, font_size=36):
    ft_library = FTLibrary()
    ft_library.init()

    ft_face = FTFace()
    ft_face.init(ft_library, font_file)
    ft_face.set_charsize(font_size*64)

    hb_font = HBFontT()
    hb_font.hb_ft_font_create(ft_face)

    hb_buffer_t = HBBufferT()
    hb_buffer_t.hb_buffer_add_utf8(string, -1, 0, -1)
    hb_buffer_t.guess_segment_properties()

    hb_shape(hb_font, hb_buffer_t, None, 0)

    my_text_len = hb_buffer_t.get_length()
    info = hb_buffer_t.get_glyph_infos()
    pos = hb_buffer_t.get_glyph_position()

    output = []

    for i in range(my_text_len):
        gid = info[i]['codepoint']
        cluster = info[i]['cluster']
        x_advance = pos[i]['x_advance'] / 64
        y_advance = pos[i]['y_advance'] / 64
        x_offset = pos[i]['x_offset'] / 64
        y_offset = pos[i]['y_offset'] / 64

        glyph_name = get_glyph_name(hb_font, gid)
        output.append({
            'cluster': cluster,
            'char': get_char_by_glyph_name(glyph_name.decode()),
            'glyph_name': glyph_name.decode(),
            'x_advance': x_advance,
            'y_advance': y_advance,
            'x_offset': x_offset,
            'y_offset': y_offset,
        })

    return output

