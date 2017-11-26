cdef extern from "stdlib.h":
    ctypedef int size_t
    void *malloc(size_t size)
    void free(void* ptr)


cdef extern from "ft2build.h":
    pass


cdef extern from "freetype/freetype.h" :
    ctypedef signed long  FT_Long
    ctypedef signed long  FT_F26Dot6
    ctypedef unsigned int  FT_UInt
    ctypedef int  FT_Error
    ctypedef void *FT_Library
    ctypedef void *FT_Face

    # ctypedef struct FT_FaceRec_:
    #   pass
    # ctypedef FT_FaceRec_* FT_Face

    # ctypedef struct FT_LibraryRec_:
    #   pass
    # ctypedef FT_LibraryRec_* FT_Library

    FT_Error FT_Init_FreeType (FT_Library *alib)
    FT_Error FT_Done_FreeType (FT_Library alib)
    FT_Error FT_Done_Face (FT_Face alib)
    FT_Error FT_New_Face( FT_Library library, char *path, unsigned long index, FT_Face *aface)
    FT_Error FT_Set_Char_Size (FT_Face aFace, unsigned int size_x, unsigned int size_y, unsigned int res_x, unsigned int res_y)


cdef extern from "hb.h" :
    # hb-common.h
    ctypedef void (*hb_destroy_func_t) (void *user_data)
    ctypedef unsigned long hb_codepoint_t
    ctypedef long hb_position_t
    ctypedef int hb_bool_t

    # hb-buffer.h
    ctypedef struct hb_buffer_t :
        pass

    hb_buffer_t* hb_buffer_create()

    void hb_buffer_add_utf8(hb_buffer_t *buffer, const char *text,
        int text_length, unsigned int item_offset, int item_length) 
    void hb_buffer_guess_segment_properties(hb_buffer_t *buffer)
    unsigned int hb_buffer_get_length (hb_buffer_t *buffer)

    ctypedef union hb_var_int_t:
        unsigned long u32

    ctypedef struct hb_glyph_position_t:
        hb_position_t x_advance
        hb_position_t y_advance
        hb_position_t x_offset
        hb_position_t y_offset
        hb_var_int_t var

    ctypedef struct hb_glyph_info_t:
        hb_codepoint_t codepoint
        # hb_mask_t mask
        unsigned long cluster

    hb_glyph_position_t * hb_buffer_get_glyph_positions(hb_buffer_t *buffer,
                               unsigned int *length);
    hb_glyph_info_t * hb_buffer_get_glyph_infos (hb_buffer_t *buffer, unsigned int *length)

    # hb-font.h
    ctypedef struct hb_font_t:
        pass

    ctypedef struct hb_face_t:
        pass

    hb_bool_t hb_font_get_glyph_name(hb_font_t *font, hb_codepoint_t glyph, char *name, unsigned int size)

    # hb-shape.h
    ctypedef struct hb_feature_t:
        pass

    void hb_shape(hb_font_t *font,
          hb_buffer_t *buffer,
          const hb_feature_t *features,
          unsigned int num_features)


cdef extern from "hb-ft.h":
    hb_face_t *hb_ft_face_create (FT_Face ft_face, hb_destroy_func_t destroy)
    hb_font_t* hb_ft_font_create(FT_Face ft_face, void * destroy)
