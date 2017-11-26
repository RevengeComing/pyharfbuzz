from . cimport charfbuzz

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
		if isinstance(font_name, str):
			font_name = font_name.encode('utf-8')
		self.cfont_name = font_name

		error = charfbuzz.FT_New_Face(ftl.ft_library, self.cfont_name, 0, &self.ft_face)
		if error:
			raise Exception("Freetype face cant be initilized.")

	def set_charsize(self, char_size):
		error = charfbuzz.FT_Set_Char_Size(self.ft_face, char_size*64, char_size*64, 0, 0)
		if error:
			raise Exception("Freetype cant set char size initilized.")


cdef class HBFontT:
	cdef charfbuzz.hb_font_t *hb_font_t
	def hb_ft_font_create(self, FTFace ftf):
		self.hb_font_t = charfbuzz.hb_ft_font_create(ftf.ft_face, NULL)


cdef class HBBufferT:
	cdef charfbuzz.hb_buffer_t *hb_buffer_t

	def __cinit__(self):
		self.hb_buffer_create()

	def hb_buffer_create(self):
		self.hb_buffer_t = charfbuzz.hb_buffer_create()

	def hb_buffer_add_utf8(self, text, text_length, item_offset, item_length):
		if isinstance(text, str):
			text = text.encode('utf-8')

		cdef const char *ctext = text
		cdef int ctext_length = text_length

		charfbuzz.hb_buffer_add_utf8(self.hb_buffer_t, ctext,
			ctext_length, item_offset, item_length)

	def guess_segment_properties(self):
		charfbuzz.hb_buffer_guess_segment_properties(self.hb_buffer_t)

	def get_length(self):
		return charfbuzz.hb_buffer_get_length(self.hb_buffer_t)

	def get_glyph_infos(self):
		cdef charfbuzz.hb_glyph_info_t *hb_glyph_info_t = charfbuzz.hb_buffer_get_glyph_infos(self.hb_buffer_t, NULL)
		glyph_info = HBGlyphInfoT()
		glyph_info.hb_buffer_get_glyph_infos(hb_glyph_info_t)
		return glyph_info


cdef class HBFeatureT:
	cdef charfbuzz.hb_feature_t *hb_feature_t


cdef class HBGlyphInfoT:
	cdef charfbuzz.hb_glyph_info_t *hb_glyph_info_t
	cdef charfbuzz.hb_glyph_info_t * hb_buffer_get_glyph_infos(self, charfbuzz.hb_glyph_info_t * hb_glyph_info_t):
		self.hb_glyph_info_t = hb_glyph_info_t



def hb_shape(HBFontT font, HBBufferT buffer, HBFeatureT feature, num_features):
	charfbuzz.hb_shape(font.hb_font_t, buffer.hb_buffer_t, feature.hb_feature_t, num_features)