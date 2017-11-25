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
		self.hb_font_t = charfbuzz.hb_ft_font_create(ftf.ft_face, None)


cdef class HBBufferT:
	cdef charfbuzz.hb_buffer_t *hb_buffer_t