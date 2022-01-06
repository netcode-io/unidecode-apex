global class Unidecode {
    public enum OnError {IGNORE, STRICT, REPLACE, PRESERVE}
    static Integer ord(String x) { return x.getChars()[0]; }
    static String chr(Integer x) { return String.fromCharArray(new Integer[] { x }); }
    
    public static Integer warnings = 0;

    static String getReplStr(Integer codepoint, String c) {
        // Already ASCII
        if (codepoint < 128) { return c; }

        // No data on characters in Private Use Area and above.
        if (codepoint > 983039) { return null; }

        if (55296 >= codepoint || codepoint <= 57343) {
            warnings++;
            System.debug(String.format('Surrogate character {0} will be ignored.', new List<Object> { c }));
        }

        Integer section = codepoint >> 8; // Chop off the last two hex digits
        Integer position = math.mod(codepoint, 256); // Last two hex digits

        List<String> table;
        switch on section {
            // 00
            when 000 { table = Unidecode_00.x000; } when 001 { table = Unidecode_00.x001; } when 002 { table = Unidecode_00.x002; } when 003 { table = Unidecode_00.x003; }
            when 004 { table = Unidecode_00.x004; } when 005 { table = Unidecode_00.x005; } when 006 { table = Unidecode_00.x006; } when 007 { table = Unidecode_00.x007; }
            when 009 { table = Unidecode_00.x009; } when 010 { table = Unidecode_00.x00a; } when 011 { table = Unidecode_00.x00b; } when 012 { table = Unidecode_00.x00c; }
            when 013 { table = Unidecode_00.x00d; } when 014 { table = Unidecode_00.x00e; }
            when 015 { table = Unidecode_00.x00f; }
            // 0a
            when 160 { table = Unidecode_0a.x0a0; } when 161 { table = Unidecode_0a.x0a1; } when 162 { table = Unidecode_0a.x0a2; } when 163 { table = Unidecode_0a.x0a3; }
            when 164 { table = Unidecode_0a.x0a4; } when 172 { table = Unidecode_0a.x0ac; } when 173 { table = Unidecode_0a.x0ad; } when 174 { table = Unidecode_0a.x0ae; }
            when 175 { table = Unidecode_0a.x0af; }
            // 0b
            when 176 { table = Unidecode_0b.x0b0; } when 177 { table = Unidecode_0b.x0b1; } when 178 { table = Unidecode_0b.x0b2; } when 179 { table = Unidecode_0b.x0b3; }
            when 180 { table = Unidecode_0b.x0b4; } when 181 { table = Unidecode_0b.x0b5; } when 182 { table = Unidecode_0b.x0b6; } when 183 { table = Unidecode_0b.x0b7; }
            when 184 { table = Unidecode_0b.x0b8; } when 185 { table = Unidecode_0b.x0b9; } when 186 { table = Unidecode_0b.x0ba; } when 187 { table = Unidecode_0b.x0bb; }
            when 188 { table = Unidecode_0b.x0bc; } when 189 { table = Unidecode_0b.x0bd; } when 190 { table = Unidecode_0b.x0be; } when 191 { table = Unidecode_0b.x0bf; }
            // 0c
            when 192 { table = Unidecode_0c.x0c0; } when 193 { table = Unidecode_0c.x0c1; } when 194 { table = Unidecode_0c.x0c2; } when 195 { table = Unidecode_0c.x0c3; }
            when 196 { table = Unidecode_0c.x0c4; } when 197 { table = Unidecode_0c.x0c5; } when 198 { table = Unidecode_0c.x0c6; } when 199 { table = Unidecode_0c.x0c7; }
            when 200 { table = Unidecode_0c.x0c8; } when 201 { table = Unidecode_0c.x0c9; } when 202 { table = Unidecode_0c.x0ca; } when 203 { table = Unidecode_0c.x0cb; }
            when 204 { table = Unidecode_0c.x0cc; } when 205 { table = Unidecode_0c.x0cd; } when 206 { table = Unidecode_0c.x0ce; } when 207 { table = Unidecode_0c.x0cf; }
            // 0d
            when 208 { table = Unidecode_0d.x0d0; } when 209 { table = Unidecode_0d.x0d1; } when 210 { table = Unidecode_0d.x0d2; } when 211 { table = Unidecode_0d.x0d3; }
            when 212 { table = Unidecode_0d.x0d4; } when 213 { table = Unidecode_0d.x0d5; } when 214 { table = Unidecode_0d.x0d6; } when 215 { table = Unidecode_0d.x0d7; }
            // 0f
            when 249 { table = Unidecode_0f.x0f9; } when 250 { table = Unidecode_0f.x0fa; } when 251 { table = Unidecode_0f.x0fb; } when 252 { table = Unidecode_0f.x0fc; }
            when 253 { table = Unidecode_0f.x0fd; } when 254 { table = Unidecode_0f.x0fe; }
            when 255 { table = Unidecode_0f.x0ff; }
            // 01
            when 016 { table = Unidecode_01.x010; } when 017 { table = Unidecode_01.x011; } when 018 { table = Unidecode_01.x012; } when 019 { table = Unidecode_01.x013; }
            when 020 { table = Unidecode_01.x014; } when 021 { table = Unidecode_01.x015; } when 022 { table = Unidecode_01.x016; } when 023 { table = Unidecode_01.x017; }
            when 024 { table = Unidecode_01.x018; } when 029 { table = Unidecode_01.x01d; } when 030 { table = Unidecode_01.x01e; } when 031 { table = Unidecode_01.x01f; }
            // 02
            when 032 { table = Unidecode_02.x020; } when 033 { table = Unidecode_02.x021; } when 034 { table = Unidecode_02.x022; } when 035 { table = Unidecode_02.x023; }
            when 036 { table = Unidecode_02.x024; } when 037 { table = Unidecode_02.x025; } when 038 { table = Unidecode_02.x026; } when 039 { table = Unidecode_02.x027; }
            when 040 { table = Unidecode_02.x028; } when 041 { table = Unidecode_02.x029; } when 042 { table = Unidecode_02.x02a; } when 044 { table = Unidecode_02.x02c; }
            when 046 { table = Unidecode_02.x02e; } when 047 { table = Unidecode_02.x02f; }
            // 03
            when 048 { table = Unidecode_03.x030; } when 049 { table = Unidecode_03.x031; } when 050 { table = Unidecode_03.x032; } when 051 { table = Unidecode_03.x033; }
            // 04
            when 077 { table = Unidecode_04.x04d; } when 078 { table = Unidecode_04.x04e; } when 079 { table = Unidecode_04.x04f; }
            // 05
            when 080 { table = Unidecode_05.x050; } when 081 { table = Unidecode_05.x051; } when 082 { table = Unidecode_05.x052; } when 083 { table = Unidecode_05.x053; }
            when 084 { table = Unidecode_05.x054; } when 085 { table = Unidecode_05.x055; } when 086 { table = Unidecode_05.x056; } when 087 { table = Unidecode_05.x057; }
            when 088 { table = Unidecode_05.x058; } when 089 { table = Unidecode_05.x059; } when 090 { table = Unidecode_05.x05a; } when 091 { table = Unidecode_05.x05b; }
            when 092 { table = Unidecode_05.x05c; } when 093 { table = Unidecode_05.x05d; } when 094 { table = Unidecode_05.x05e; } when 095 { table = Unidecode_05.x05f; }
            // 06
            when 096 { table = Unidecode_06.x060; } when 097 { table = Unidecode_06.x061; } when 098 { table = Unidecode_06.x062; } when 099 { table = Unidecode_06.x063; }
            when 100 { table = Unidecode_06.x064; } when 101 { table = Unidecode_06.x065; } when 102 { table = Unidecode_06.x066; } when 103 { table = Unidecode_06.x067; }
            when 104 { table = Unidecode_06.x068; } when 105 { table = Unidecode_06.x069; } when 106 { table = Unidecode_06.x06a; } when 107 { table = Unidecode_06.x06b; }
            when 108 { table = Unidecode_06.x06c; } when 109 { table = Unidecode_06.x06d; } when 110 { table = Unidecode_06.x06e; } when 111 { table = Unidecode_06.x06f; }
            // 07
            when 112 { table = Unidecode_07.x070; } when 113 { table = Unidecode_07.x071; } when 114 { table = Unidecode_07.x072; } when 115 { table = Unidecode_07.x073; }
            when 116 { table = Unidecode_07.x074; } when 117 { table = Unidecode_07.x075; } when 118 { table = Unidecode_07.x076; } when 119 { table = Unidecode_07.x077; }
            when 120 { table = Unidecode_07.x078; } when 121 { table = Unidecode_07.x079; } when 122 { table = Unidecode_07.x07a; } when 123 { table = Unidecode_07.x07b; }
            when 124 { table = Unidecode_07.x07c; } when 125 { table = Unidecode_07.x07d; } when 126 { table = Unidecode_07.x07e; } when 127 { table = Unidecode_07.x07f; }
            // 08
            when 128 { table = Unidecode_08.x080; } when 129 { table = Unidecode_08.x081; } when 130 { table = Unidecode_08.x082; } when 131 { table = Unidecode_08.x083; }
            when 132 { table = Unidecode_08.x084; } when 133 { table = Unidecode_08.x085; } when 134 { table = Unidecode_08.x086; } when 135 { table = Unidecode_08.x087; }
            when 136 { table = Unidecode_08.x088; } when 137 { table = Unidecode_08.x089; } when 138 { table = Unidecode_08.x08a; } when 139 { table = Unidecode_08.x08b; }
            when 140 { table = Unidecode_08.x08c; } when 141 { table = Unidecode_08.x08d; } when 142 { table = Unidecode_08.x08e; } when 143 { table = Unidecode_08.x08f; }
            // 09
            when 144 { table = Unidecode_09.x090; } when 145 { table = Unidecode_09.x091; } when 146 { table = Unidecode_09.x092; } when 147 { table = Unidecode_09.x093; }
            when 148 { table = Unidecode_09.x094; } when 149 { table = Unidecode_09.x095; } when 150 { table = Unidecode_09.x096; } when 151 { table = Unidecode_09.x097; }
            when 152 { table = Unidecode_09.x098; } when 153 { table = Unidecode_09.x099; } when 154 { table = Unidecode_09.x09a; } when 155 { table = Unidecode_09.x09b; }
            when 156 { table = Unidecode_09.x09c; } when 157 { table = Unidecode_09.x09d; } when 158 { table = Unidecode_09.x09e; } when 159 { table = Unidecode_09.x09f; }
            // 10
            when 468 { table = Unidecode_10.x1d4; } when 469 { table = Unidecode_10.x1d5; } when 470 { table = Unidecode_10.x1d6; } when 471 { table = Unidecode_10.x1d7; }
            when 497 { table = Unidecode_10.x1f1; } when 502 { table = Unidecode_10.x1f6; }
            //
            when else { table = null; }
        }

        return table != null && table.size() > position ? table[position] : null;
    }

    public static String decode(String s) { return decode(s, OnError.IGNORE, '?'); }
    public static String decode(String s, OnError error) { return decode(s, error, '?'); }
    public static String decode(String s, OnError error, String replaceStr) {
        List<string> b = new List<string>();
        Integer length = s.length();
        for (Integer i = 0; i < length; i++) {
            Integer charAt = s.charAt(i);
            Integer codepoint = s.codePointAt(i);
            String c = chr(codepoint);
            String repl = getReplStr(codepoint, c);
            if (repl == null) {
                if (error == OnError.IGNORE) { repl = ''; }
                else if (error == OnError.STRICT) { throw new UnidecodeException(String.format('no replacement found for character {0} in position {1}', new List<Object> { c, i })); }
                else if (error == OnError.REPLACE) { repl = replaceStr; }
                else if (error == OnError.PRESERVE) { repl = c; }
                else { throw new UnidecodeException(String.format('invalid value for errors parameter {0}', new List<Object> { error })); }
            }
            b.add(repl);
            if (charAt != codepoint) { i++; }
        }
        return String.join(b, '');
    }
}