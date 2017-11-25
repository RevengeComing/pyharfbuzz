from pyharfbuzz import FTLibrary, FTFace, HBFontT, HBBufferT


def main():
    # init freetype library
    ft_library = FTLibrary()
    ft_library.init()

    ft_face = FTFace()
    ft_face.init(ft_library, "Vazir.ttf")
    ft_face.set_charsize(36)

if __name__ == '__main__':
    main()