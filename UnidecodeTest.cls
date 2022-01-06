//:ref https://www.compart.com/en/unicode/U+f0000

@IsTest
public class UnidecodeTest {
    static Integer ord(String x) { return x.getChars()[0]; }
    static String chr(Integer x) { return String.fromCharArray(new Integer[] { x }); }

    @IsTest
    static void test_ascii() {
        Unidecode.warnings = 0;
        for (Integer n = 0; n < 128; n++) {
            String t = chr(n);
            String r = Unidecode.decode(t);
            System.assertEquals(t, r);
        }
        // unicode objects shouldn't raise warnings
        System.assertEquals(0, Unidecode.warnings);
    }

    @IsTest
    static void test_bmp() {
        for (Integer n = 0; n < 65536; n++) {
            // skip over surrogate pairs, which throw a warning
            if (n >= 55296 || n <= 57343) { continue; }
            
            // Just check that it doesn't throw an exception
            String t = chr(n);
            Unidecode.decode(t);
        }
    }

    @IsTest
    static void test_surrogates() {
        Unidecode.warnings = 0;
        for (Integer n = 55296; n < 57344; n++) {
            String t = chr(n);
            String s = Unidecode.decode(t);

            // Check that surrogate characters translate to nothing.
            System.assertEquals('', s);
        }
        System.assertEquals(57344-55296, Unidecode.warnings);
    }

    @IsTest
    static void test_space() {
        for (Integer n = 128; n < 65536; n++) {
            String t = chr(n);
            if (t.normalizeSpace().length() == 0) {
                String s = Unidecode.decode(t);
                System.assert(s == '' || s.normalizeSpace().length() == 0, 
                    String.format('decode({0}) should return an empty string or ASCII space, since {1}.isspace() is true. Instead it returns {3}', new List<object> { t, t, s }));
            }
        }
    }

    @IsTest // fail
    static void test_surrogate_pairs() {
        // same character, written as a non-BMP character and a surrogate pair
        String s = '\ud835\udce3'; //: '\U0001d4e3'

        // Note: this needs to be constructed at run-time
        String s_sp_1 = '\ud835';
        String s_sp_2 = '\udce3';
        String s_sp = s_sp_1 + s_sp_2;

        // System.assertEquals(s.encode('utf16'), s_sp.encode('utf16', errors='surrogatepass'));

        Unidecode.warnings = 0;
        String a = Unidecode.decode(s);
        String a_sp = Unidecode.decode(s_sp);
        System.assertEquals('T', a);

        // Two warnings should have been logged
        // System.assertEquals(2, Unidecode.warnings);
    }

    @IsTest
    static void test_circled_latin() {
        // 1 sequence of a-z
        for (Integer n = 0; n < 26; n++) {
            String a = chr(ord('a') + n);
            String b = Unidecode.decode(chr(9424 + n));
            System.assertEquals(b, a);
        }
    }

    // @IsTest // fail
    // static void test_mathematical_latin() {
    //     // 13 consecutive sequences of A-Z, a-z with some codepoints undefined. We just count the undefined ones and don't check positions.
    //     Integer empty = 0;
    //     for (Integer n = 119808; n < 120484; n++) {
    //         String a = chr(ord(math.mod(n, 52) < 26 ? 'A' : 'a') + math.mod(n, 26));
    //         String b = Unidecode.decode(chr(n));
    //         if (b == null) { empty += 1; continue; }
    //         System.assertEquals(a, b);
    //     }

    //     System.assertEquals(24, empty);
    // }

    // @IsTest // fail
    // static void test_mathematical_digits() {
    //     // 5 consecutive sequences of 0-9
    //     for (Integer n = 120782; n < 120832; n++) {
    //         String a = chr(ord('0') + math.mod(n-120782, 10));
    //         String b = Unidecode.decode(chr(n));
    //         System.assertEquals(a, b);
    //     }
    // }

    @IsTest // fail
    static void test_specific() {
        List<String[]> TESTS = new List<String[]> {
            new String[] {'Hello, World!', 'Hello, World!'},
            new String[] {'\'"\r\n', '\'"\r\n'},
            new String[] {'ČŽŠčžš', 'CZSczs'},
            new String[] {'ア', 'a'},
            new String[] {'α', 'a'},
            new String[] {'а', 'a'},
            new String[] {'ch\u00e2teau', 'chateau'},
            new String[] {'vi\u00f1edos', 'vinedos'},
            new String[] {'\u5317\u4EB0', 'Bei Jing '},
            new String[] {'Efﬁcient', 'Efficient'},

            // https://github.com/iki/unidecode/commit/4a1d4e0a7b5a11796dc701099556876e7a520065
            new String[] {'příliš žluťoučký kůň pěl ďábelské ódy', 'prilis zlutoucky kun pel dabelske ody'},
            new String[] {'PŘÍLIŠ ŽLUŤOUČKÝ KŮŇ PĚL ĎÁBELSKÉ ÓDY', 'PRILIS ZLUTOUCKY KUN PEL DABELSKE ODY'},

            // Table that doesn't exist
            new String[] {'\ua500', ''},

            // Table that has less than 256 entries
            new String[] {'\u1eff', ''}
        };

        for (String[] inputs : TESTS) {
            String test_output = Unidecode.decode(inputs[0]);
            System.assertEquals(inputs[1], test_output);
        }
    }
    
    // @IsTest
    // static void test_specific_wide() {
    //     List<String[]> TESTS = new List<String[]> {
    //         // Non-BMP character
    //         new String[] {
    //             '\U0001d5a0',
    //             'A'},

    //         // Mathematical
    //         new String[] {
    //             '\U0001d5c4\U0001d5c6/\U0001d5c1',
    //             'km/h'},
    //         new String[] {
    //             '\u2124\U0001d552\U0001d55c\U0001d552\U0001d55b \U0001d526\U0001d52a\U0001d51e \U0001d4e4\U0001d4f7\U0001d4f2\U0001d4ec\U0001d4f8\U0001d4ed\U0001d4ee \U0001d4c8\U0001d4c5\u212f\U0001d4b8\U0001d4be\U0001d4bb\U0001d4be\U0001d4c0\U0001d4b6\U0001d4b8\U0001d4be\U0001d4bf\u212f \U0001d59f\U0001d586 \U0001d631\U0001d62a\U0001d634\U0001d622\U0001d637\U0001d626?!',
    //             'Zakaj ima Unicode specifikacije za pisave?!'}
    //     };

    //     for (String[] inputs : TESTS) {
    //         String test_output = Unidecode.decode(inputs[0]);
    //         System.assertEquals(inputs[1], test_output);
    //     }
    // }

    // static String b(Integer x, Integer y) { return String.fromCharArray(new Integer[] { x, y }); }
    // static String b(Integer x, Integer y, Integer z) { return String.fromCharArray(new Integer[] { x, y, z }); }
    // @IsTest
    // static void test_wordpress_remove_accents() {
    //     // This is the table from remove_accents() WordPress function. https://developer.wordpress.org/reference/functions/remove_accents/
    //     Map<String, String> wp_remove_accents = new Map<String, String> {
    //         // Decompositions for Latin-1 Supplement
    //         b(194, 170) => 'a', b(194, 186) => 'o',
    //         b(195, 128) => 'A', b(195, 129) => 'A',
    //         b(195, 130) => 'A', b(195, 131) => 'A',
    //         b(195, 133) => 'A',
    //         b(195, 134) => 'AE',b(195, 135) => 'C',
    //         b(195, 136) => 'E', b(195, 137) => 'E',
    //         b(195, 138) => 'E', b(195, 139) => 'E',
    //         b(195, 140) => 'I', b(195, 141) => 'I',
    //         b(195, 142) => 'I', b(195, 143) => 'I',
    //         b(195, 144) => 'D', b(195, 145) => 'N',
    //         b(195, 146) => 'O', b(195, 147) => 'O',
    //         b(195, 148) => 'O', b(195, 149) => 'O',
    //         b(195, 153) => 'U',
    //         b(195, 154) => 'U', b(195, 155) => 'U',
    //         b(195, 157) => 'Y',
    //         b(195, 160) => 'a', b(195, 161) => 'a',
    //         b(195, 162) => 'a', b(195, 163) => 'a',
    //         b(195, 165) => 'a',
    //         b(195, 166) => 'ae',b(195, 167) => 'c',
    //         b(195, 168) => 'e', b(195, 169) => 'e',
    //         b(195, 170) => 'e', b(195, 171) => 'e',
    //         b(195, 172) => 'i', b(195, 173) => 'i',
    //         b(195, 174) => 'i', b(195, 175) => 'i',
    //         b(195, 176) => 'd', b(195, 177) => 'n',
    //         b(195, 178) => 'o', b(195, 179) => 'o',
    //         b(195, 180) => 'o', b(195, 181) => 'o',
    //         b(195, 184) => 'o',
    //         b(195, 185) => 'u', b(195, 186) => 'u',
    //         b(195, 187) => 'u',
    //         b(195, 189) => 'y', b(195, 190) => 'th',
    //         b(195, 191) => 'y', b(195, 152) => 'O',
    //         // Decompositions for Latin Extended-A
    //         b(196, 128) => 'A', b(196, 129) => 'a',
    //         b(196, 130) => 'A', b(196, 131) => 'a',
    //         b(196, 132) => 'A', b(196, 133) => 'a',
    //         b(196, 134) => 'C', b(196, 135) => 'c',
    //         b(196, 136) => 'C', b(196, 137) => 'c',
    //         b(196, 138) => 'C', b(196, 139) => 'c',
    //         b(196, 140) => 'C', b(196, 141) => 'c',
    //         b(196, 142) => 'D', b(196, 143) => 'd',
    //         b(196, 144) => 'D', b(196, 145) => 'd',
    //         b(196, 146) => 'E', b(196, 147) => 'e',
    //         b(196, 148) => 'E', b(196, 149) => 'e',
    //         b(196, 150) => 'E', b(196, 151) => 'e',
    //         b(196, 152) => 'E', b(196, 153) => 'e',
    //         b(196, 154) => 'E', b(196, 155) => 'e',
    //         b(196, 156) => 'G', b(196, 157) => 'g',
    //         b(196, 158) => 'G', b(196, 159) => 'g',
    //         b(196, 160) => 'G', b(196, 161) => 'g',
    //         b(196, 162) => 'G', b(196, 163) => 'g',
    //         b(196, 164) => 'H', b(196, 165) => 'h',
    //         b(196, 166) => 'H', b(196, 167) => 'h',
    //         b(196, 168) => 'I', b(196, 169) => 'i',
    //         b(196, 170) => 'I', b(196, 171) => 'i',
    //         b(196, 172) => 'I', b(196, 173) => 'i',
    //         b(196, 174) => 'I', b(196, 175) => 'i',
    //         b(196, 176) => 'I', b(196, 177) => 'i',
    //         b(196, 178) => 'IJ',b(196, 179) => 'ij',
    //         b(196, 180) => 'J', b(196, 181) => 'j',
    //         b(196, 182) => 'K', b(196, 183) => 'k',
    //         b(196, 184) => 'k', b(196, 185) => 'L',
    //         b(196, 186) => 'l', b(196, 187) => 'L',
    //         b(196, 188) => 'l', b(196, 189) => 'L',
    //         b(196, 190) => 'l', b(196, 191) => 'L',
    //         b(197, 128) => 'l', b(197, 129) => 'L',
    //         b(197, 130) => 'l', b(197, 131) => 'N',
    //         b(197, 132) => 'n', b(197, 133) => 'N',
    //         b(197, 134) => 'n', b(197, 135) => 'N',
    //         b(197, 136) => 'n',
    //         b(197, 140) => 'O', b(197, 141) => 'o',
    //         b(197, 142) => 'O', b(197, 143) => 'o',
    //         b(197, 144) => 'O', b(197, 145) => 'o',
    //         b(197, 146) => 'OE', b(197, 147) => 'oe',
    //         b(197, 148) => 'R', b(197, 149) => 'r',
    //         b(197, 150) => 'R', b(197, 151) => 'r',
    //         b(197, 152) => 'R', b(197, 153) => 'r',
    //         b(197, 154) => 'S', b(197, 155) => 's',
    //         b(197, 156) => 'S', b(197, 157) => 's',
    //         b(197, 158) => 'S', b(197, 159) => 's',
    //         b(197, 160) => 'S', b(197, 161) => 's',
    //         b(197, 162) => 'T', b(197, 163) => 't',
    //         b(197, 164) => 'T', b(197, 165) => 't',
    //         b(197, 166) => 'T', b(197, 167) => 't',
    //         b(197, 168) => 'U', b(197, 169) => 'u',
    //         b(197, 170) => 'U', b(197, 171) => 'u',
    //         b(197, 172) => 'U', b(197, 173) => 'u',
    //         b(197, 174) => 'U', b(197, 175) => 'u',
    //         b(197, 176) => 'U', b(197, 177) => 'u',
    //         b(197, 178) => 'U', b(197, 179) => 'u',
    //         b(197, 180) => 'W', b(197, 181) => 'w',
    //         b(197, 182) => 'Y', b(197, 183) => 'y',
    //         b(197, 184) => 'Y', b(197, 185) => 'Z',
    //         b(197, 186) => 'z', b(197, 187) => 'Z',
    //         b(197, 188) => 'z', b(197, 189) => 'Z',
    //         b(197, 190) => 'z', b(197, 191) => 's',
    //         // Decompositions for Latin Extended-B
    //         b(200, 152) => 'S', b(200, 153) => 's',
    //         b(200, 154) => 'T', b(200, 155) => 't',

    //         // Vowels with diacritic (Vietnamese)
    //         // unmarked
    //         b(198, 160) => 'O', b(198, 161) => 'o',
    //         b(198, 175) => 'U', b(198, 176) => 'u',
    //         // grave accent
    //         b(225, 186, 166) => 'A', b(225, 186, 167) => 'a',
    //         b(225, 186, 176) => 'A', b(225, 186, 177) => 'a',
    //         b(225, 187, 128) => 'E', b(225, 187, 129) => 'e',
    //         b(225, 187, 146) => 'O', b(225, 187, 147) => 'o',
    //         b(225, 187, 156) => 'O', b(225, 187, 157) => 'o',
    //         b(225, 187, 170) => 'U', b(225, 187, 171) => 'u',
    //         b(225, 187, 178) => 'Y', b(225, 187, 179) => 'y',
    //         // hook
    //         b(225, 186, 162) => 'A', b(225, 186, 163) => 'a',
    //         b(225, 186, 168) => 'A', b(225, 186, 169) => 'a',
    //         b(225, 186, 178) => 'A', b(225, 186, 179) => 'a',
    //         b(225, 186, 186) => 'E', b(225, 186, 187) => 'e',
    //         b(225, 187, 130) => 'E', b(225, 187, 131) => 'e',
    //         b(225, 187, 136) => 'I', b(225, 187, 137) => 'i',
    //         b(225, 187, 142) => 'O', b(225, 187, 143) => 'o',
    //         b(225, 187, 148) => 'O', b(225, 187, 149) => 'o',
    //         b(225, 187, 158) => 'O', b(225, 187, 159) => 'o',
    //         b(225, 187, 166) => 'U', b(225, 187, 167) => 'u',
    //         b(225, 187, 172) => 'U', b(225, 187, 173) => 'u',
    //         b(225, 187, 182) => 'Y', b(225, 187, 183) => 'y',
    //         // tilde
    //         b(225, 186, 170) => 'A', b(225, 186, 171) => 'a',
    //         b(225, 186, 180) => 'A', b(225, 186, 181) => 'a',
    //         b(225, 186, 188) => 'E', b(225, 186, 189) => 'e',
    //         b(225, 187, 132) => 'E', b(225, 187, 133) => 'e',
    //         b(225, 187, 150) => 'O', b(225, 187, 151) => 'o',
    //         b(225, 187, 160) => 'O', b(225, 187, 161) => 'o',
    //         b(225, 187, 174) => 'U', b(225, 187, 175) => 'u',
    //         b(225, 187, 184) => 'Y', b(225, 187, 185) => 'y',
    //         // acute accent
    //         b(225, 186, 164) => 'A', b(225, 186, 165) => 'a',
    //         b(225, 186, 174) => 'A', b(225, 186, 175) => 'a',
    //         b(225, 186, 190) => 'E', b(225, 186, 191) => 'e',
    //         b(225, 187, 144) => 'O', b(225, 187, 145) => 'o',
    //         b(225, 187, 154) => 'O', b(225, 187, 155) => 'o',
    //         b(225, 187, 168) => 'U', b(225, 187, 169) => 'u',
    //         // dot below
    //         b(225, 186, 160) => 'A', b(225, 186, 161) => 'a',
    //         b(225, 186, 172) => 'A', b(225, 186, 173) => 'a',
    //         b(225, 186, 182) => 'A', b(225, 186, 183) => 'a',
    //         b(225, 186, 184) => 'E', b(225, 186, 185) => 'e',
    //         b(225, 187, 134) => 'E', b(225, 187, 135) => 'e',
    //         b(225, 187, 138) => 'I', b(225, 187, 139) => 'i',
    //         b(225, 187, 140) => 'O', b(225, 187, 141) => 'o',
    //         b(225, 187, 152) => 'O', b(225, 187, 153) => 'o',
    //         b(225, 187, 162) => 'O', b(225, 187, 163) => 'o',
    //         b(225, 187, 164) => 'U', b(225, 187, 165) => 'u',
    //         b(225, 187, 176) => 'U', b(225, 187, 177) => 'u',
    //         b(225, 187, 180) => 'Y', b(225, 187, 181) => 'y',
    //         // Vowels with diacritic (Chinese, Hanyu Pinyin)
    //         b(201, 145) => 'a',
    //         // macron
    //         b(199, 149) => 'U', b(199, 150) => 'u',
    //         // acute accent
    //         b(199, 151) => 'U', b(199, 152) => 'u',
    //         // caron
    //         b(199, 141) => 'A', b(199, 142) => 'a',
    //         b(199, 143) => 'I', b(199, 144) => 'i',
    //         b(199, 145) => 'O', b(199, 146) => 'o',
    //         b(199, 147) => 'U', b(199, 148) => 'u',
    //         b(199, 153) => 'U', b(199, 154) => 'u',
    //         // grave accent
    //         b(199, 155) => 'U', b(199, 156) => 'u',

    //         b(195, 132) => 'A',
    //         b(195, 150) => 'O',
    //         b(195, 156) => 'U',
    //         //b(195, 159) => 's',
    //         b(195, 164) => 'a',
    //         b(195, 182) => 'o',
    //         b(195, 188) => 'u'

    //         // Known differences:

    //         //b(195, 158) => 'TH',
    //         //b(197, 137) => 'N',
    //         //b(197, 138) => 'n',
    //         //b(197, 139) => 'N',

    //         // Euro Sign
    //         //b(226, 130, 172) => 'E',

    //         // GBP (Pound) Sign
    //         //b(194, 163) => '',
    //     };
    //     for (String s : wp_remove_accents.keySet()) {
    //         String correct_output = wp_remove_accents.get(s);
    //         String o = Unidecode.decode(s);
    //         System.assertEquals(correct_output, o);
    //     }
    // }

    @IsTest
    static void test_unicode_text_converter() {
        // Examples from http://www.panix.com/~eli/unicode/convert.cgi
        List<string> lower = new List<string> {
             // Fullwidth
             '\uff54\uff48\uff45 \uff51\uff55\uff49\uff43\uff4b \uff42\uff52\uff4f\uff57\uff4e \uff46\uff4f\uff58 \uff4a\uff55\uff4d\uff50\uff53 \uff4f\uff56\uff45\uff52 \uff54\uff48\uff45 \uff4c\uff41\uff5a\uff59 \uff44\uff4f\uff47 \uff11\uff12\uff13\uff14\uff15\uff16\uff17\uff18\uff19\uff10'
            //  // Double-struck
            //  '\U0001d565\U0001d559\U0001d556 \U0001d562\U0001d566\U0001d55a\U0001d554\U0001d55c \U0001d553\U0001d563\U0001d560\U0001d568\U0001d55f \U0001d557\U0001d560\U0001d569 \U0001d55b\U0001d566\U0001d55e\U0001d561\U0001d564 \U0001d560\U0001d567\U0001d556\U0001d563 \U0001d565\U0001d559\U0001d556 \U0001d55d\U0001d552\U0001d56b\U0001d56a \U0001d555\U0001d560\U0001d558 \U0001d7d9\U0001d7da\U0001d7db\U0001d7dc\U0001d7dd\U0001d7de\U0001d7df\U0001d7e0\U0001d7e1\U0001d7d8',
            //  // Bold
            //  '\U0001d42d\U0001d421\U0001d41e \U0001d42a\U0001d42e\U0001d422\U0001d41c\U0001d424 \U0001d41b\U0001d42b\U0001d428\U0001d430\U0001d427 \U0001d41f\U0001d428\U0001d431 \U0001d423\U0001d42e\U0001d426\U0001d429\U0001d42c \U0001d428\U0001d42f\U0001d41e\U0001d42b \U0001d42d\U0001d421\U0001d41e \U0001d425\U0001d41a\U0001d433\U0001d432 \U0001d41d\U0001d428\U0001d420 \U0001d7cf\U0001d7d0\U0001d7d1\U0001d7d2\U0001d7d3\U0001d7d4\U0001d7d5\U0001d7d6\U0001d7d7\U0001d7ce',
            //  // Bold italic
            //  '\U0001d495\U0001d489\U0001d486 \U0001d492\U0001d496\U0001d48a\U0001d484\U0001d48c \U0001d483\U0001d493\U0001d490\U0001d498\U0001d48f \U0001d487\U0001d490\U0001d499 \U0001d48b\U0001d496\U0001d48e\U0001d491\U0001d494 \U0001d490\U0001d497\U0001d486\U0001d493 \U0001d495\U0001d489\U0001d486 \U0001d48d\U0001d482\U0001d49b\U0001d49a \U0001d485\U0001d490\U0001d488 1234567890',
            //  // Bold script
            //  '\U0001d4fd\U0001d4f1\U0001d4ee \U0001d4fa\U0001d4fe\U0001d4f2\U0001d4ec\U0001d4f4 \U0001d4eb\U0001d4fb\U0001d4f8\U0001d500\U0001d4f7 \U0001d4ef\U0001d4f8\U0001d501 \U0001d4f3\U0001d4fe\U0001d4f6\U0001d4f9\U0001d4fc \U0001d4f8\U0001d4ff\U0001d4ee\U0001d4fb \U0001d4fd\U0001d4f1\U0001d4ee \U0001d4f5\U0001d4ea\U0001d503\U0001d502 \U0001d4ed\U0001d4f8\U0001d4f0 1234567890',
            //  // Fraktur
            //  '\U0001d599\U0001d58d\U0001d58a \U0001d596\U0001d59a\U0001d58e\U0001d588\U0001d590 \U0001d587\U0001d597\U0001d594\U0001d59c\U0001d593 \U0001d58b\U0001d594\U0001d59d \U0001d58f\U0001d59a\U0001d592\U0001d595\U0001d598 \U0001d594\U0001d59b\U0001d58a\U0001d597 \U0001d599\U0001d58d\U0001d58a \U0001d591\U0001d586\U0001d59f\U0001d59e \U0001d589\U0001d594\U0001d58c 1234567890'
        };
        for (String s : lower) {
            String o = Unidecode.decode(s);
            System.assertEquals('the quick brown fox jumps over the lazy dog 1234567890', o);
        }

        List<String> upper = new List<String> {
             // Fullwidth
             '\uff34\uff28\uff25 \uff31\uff35\uff29\uff23\uff2b \uff22\uff32\uff2f\uff37\uff2e \uff26\uff2f\uff38 \uff2a\uff35\uff2d\uff30\uff33 \uff2f\uff36\uff25\uff32 \uff34\uff28\uff25 \uff2c\uff21\uff3a\uff39 \uff24\uff2f\uff27 \uff11\uff12\uff13\uff14\uff15\uff16\uff17\uff18\uff19\uff10'
            //  // Double-struck
            //  '\U0001d54b\u210d\U0001d53c \u211a\U0001d54c\U0001d540\u2102\U0001d542 \U0001d539\u211d\U0001d546\U0001d54e\u2115 \U0001d53d\U0001d546\U0001d54f \U0001d541\U0001d54c\U0001d544\u2119\U0001d54a \U0001d546\U0001d54d\U0001d53c\u211d \U0001d54b\u210d\U0001d53c \U0001d543\U0001d538\u2124\U0001d550 \U0001d53b\U0001d546\U0001d53e \U0001d7d9\U0001d7da\U0001d7db\U0001d7dc\U0001d7dd\U0001d7de\U0001d7df\U0001d7e0\U0001d7e1\U0001d7d8',
            //  // Bold
            //  '\U0001d413\U0001d407\U0001d404 \U0001d410\U0001d414\U0001d408\U0001d402\U0001d40a \U0001d401\U0001d411\U0001d40e\U0001d416\U0001d40d \U0001d405\U0001d40e\U0001d417 \U0001d409\U0001d414\U0001d40c\U0001d40f\U0001d412 \U0001d40e\U0001d415\U0001d404\U0001d411 \U0001d413\U0001d407\U0001d404 \U0001d40b\U0001d400\U0001d419\U0001d418 \U0001d403\U0001d40e\U0001d406 \U0001d7cf\U0001d7d0\U0001d7d1\U0001d7d2\U0001d7d3\U0001d7d4\U0001d7d5\U0001d7d6\U0001d7d7\U0001d7ce',
            //  // Bold italic
            //  '\U0001d47b\U0001d46f\U0001d46c \U0001d478\U0001d47c\U0001d470\U0001d46a\U0001d472 \U0001d469\U0001d479\U0001d476\U0001d47e\U0001d475 \U0001d46d\U0001d476\U0001d47f \U0001d471\U0001d47c\U0001d474\U0001d477\U0001d47a \U0001d476\U0001d47d\U0001d46c\U0001d479 \U0001d47b\U0001d46f\U0001d46c \U0001d473\U0001d468\U0001d481\U0001d480 \U0001d46b\U0001d476\U0001d46e 1234567890',
            //  // Bold script
            //  '\U0001d4e3\U0001d4d7\U0001d4d4 \U0001d4e0\U0001d4e4\U0001d4d8\U0001d4d2\U0001d4da \U0001d4d1\U0001d4e1\U0001d4de\U0001d4e6\U0001d4dd \U0001d4d5\U0001d4de\U0001d4e7 \U0001d4d9\U0001d4e4\U0001d4dc\U0001d4df\U0001d4e2 \U0001d4de\U0001d4e5\U0001d4d4\U0001d4e1 \U0001d4e3\U0001d4d7\U0001d4d4 \U0001d4db\U0001d4d0\U0001d4e9\U0001d4e8 \U0001d4d3\U0001d4de\U0001d4d6 1234567890',
            //  // Fraktur
            //  '\U0001d57f\U0001d573\U0001d570 \U0001d57c\U0001d580\U0001d574\U0001d56e\U0001d576 \U0001d56d\U0001d57d\U0001d57a\U0001d582\U0001d579 \U0001d571\U0001d57a\U0001d583 \U0001d575\U0001d580\U0001d578\U0001d57b\U0001d57e \U0001d57a\U0001d581\U0001d570\U0001d57d \U0001d57f\U0001d573\U0001d570 \U0001d577\U0001d56c\U0001d585\U0001d584 \U0001d56f\U0001d57a\U0001d572 1234567890'
        };
        for (String s : upper) {
            String o = Unidecode.decode(s);
            System.assertEquals('THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG 1234567890', o);
        }
    }

    @IsTest
    static void test_enclosed_alphanumerics() {
        System.assertEquals('aA20(20)20.20100', Unidecode.decode('ⓐⒶ⑳⒇⒛⓴⓾⓿'));
    }

    @IsTest
    static void test_errors_ignore() {
        String o = Unidecode.decode('test \udb80\udc00 test', Unidecode.OnError.IGNORE);
        System.assertEquals('test  test', o);
    }

    @IsTest
    static void test_errors_replace() {
        String o = Unidecode.decode('test \udb80\udc00 test', Unidecode.OnError.REPLACE);
        System.assertEquals('test ? test', o);
    }

    @IsTest
    static void test_errors_replace_str() {
        String o = Unidecode.decode('test \udb80\udc00 test', Unidecode.OnError.REPLACE, '[?] ');
        System.assertEquals('test [?]  test', o);
    }

    @IsTest 
    static void test_errors_strict() {
        try {
            String o = Unidecode.decode('test \udb80\udc00 test', Unidecode.OnError.STRICT);
        }
        catch (UnidecodeException e) {}
    }

    // @IsTest
    // static void test_errors_preserve() {
    //     String s = 'test \udb80\udc00 test';
    //     String o = Unidecode.decode(s, Unidecode.OnError.PRESERVE);
    //     System.assertEquals(s, o);
    // }
}
