

cdef extern from "/usr/include/harfbuzz/hb.h":
	pass

cdef extern from "/usr/include/harfbuzz/hb-ft.h":
	ctypedef signed long  FT_Long;
	ctypedef signed long  FT_F26Dot6;
	ctypedef unsigned int  FT_UInt;

	ctypedef struct FT_LibraryRec_:
		pass
	ctypedef FT_LibraryRec_* FT_Library

	ctypedef struct FT_FaceRec_:
		pass
	ctypedef FT_FaceRec_* FT_Face

	ctypedef int  FT_Error;

	FT_Error FT_Init_FreeType(FT_Library *alibrary)
	FT_Error FT_New_Face(FT_Library alibrary, const char *filepathname, FT_Long face_index, FT_Face *aface)
	FT_Error FT_Set_Char_Size(FT_Face aface, FT_F26Dot6 char_width,
		FT_F26Dot6 char_height, FT_UInt horz_resolution, FT_UInt vert_resolution)

	ctypedef struct hb_font_t:
		pass

	hb_font_t* hb_ft_font_create(FT_Face ft_face, None)

	ctypedef struct hb_buffer_t:
		pass

	hb_buffer_t* hb_buffer_create()
	void hb_buffer_add_utf8(hb_buffer_t *buffer, const char *text,
		int text_length, unsigned int item_offset, int item_length)
	void hb_buffer_guess_segment_properties(hb_buffer_t *buffer);

	ctypedef struct hb_feature_t:
		pass

	void hb_shape (hb_font_t *font,
          hb_buffer_t *buffer,
          const hb_feature_t *features,
          unsigned int num_features);

	unsigned int hb_buffer_get_length (hb_buffer_t *buffer);
