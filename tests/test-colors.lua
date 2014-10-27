local utils = require('utils')
local dump = utils.dump
local strip = utils.strip

require('tap')(function (test)

  test("Recursive values", function ()
    local data = {a="value"}
    data.data = data
    local out = dump(data)
    local stripped = strip(out)
    print("recursive", out, dump(stripped))
    assert(string.match(stripped, "{ a = 'value', data = table: 0x%x+ }"))
  end)

  test("string escapes", function ()
    local tests = {
      '\000\001\002\003\004\005\006\a\b\t\n\v\f\r\014\015',  "'\\000\\001\\002\\003\\004\\005\\006\\a\\b\\t\\n\\v\\f\\r\\014\\015'",
      '\016\017\018\019\020\021\022\023\024\025\026\027\028\029\030\031',  "'\\016\\017\\018\\019\\020\\021\\022\\023\\024\\025\\026\\027\\028\\029\\030\\031'",
      ' !"#$%&\'()*+,-./', '\' !"#$%&\\\'()*+,-./\'',
      '0123456789:;<=>?',  "'0123456789:;<=>?'",
      '@ABCDEFGHIJKLMNO',  "'@ABCDEFGHIJKLMNO'",
      'PQRSTUVWXYZ[\\]^_', "'PQRSTUVWXYZ[\\\\]^_'",
      '`abcdefghijklmno',  "'`abcdefghijklmno'",
      'pqrstuvwxyz{|}',  "'pqrstuvwxyz{|}'",
    }
    for i = 1, 16, 2 do
      local out = dump(tests[i])
      local stripped = strip(out)
      print(out, dump(stripped))
      assert(stripped == tests[i + 1])
    end

  end)

  test("Color mode switching", function ()
    local data = {42,true,"A\nstring"}

    utils.loadColors()
    local plain = dump(data)
    print("plain", plain, dump(plain))
    assert(plain == "{ 42, true, 'A\\nstring' }")

    utils.loadColors(16)
    local colored = dump(data)
    print("colored", colored, dump(colored))
    assert(colored == "\027[1;30m{ \027[0m\027[1;33m42\027[0m\027[1;30m, \027[0m\027[0;33mtrue\027[0m\027[1;30m, \027[0m\027[1;32m'\027[0;32mA\027[1;32m\\n\027[0;32mstring\027[1;32m'\027[0m \027[1;30m}\027[0m")

    utils.loadColors(256)
    local super = dump(data)
    print("super", super, dump(super))
    assert(super == "\027[38;5;247m{ \027[0m\027[38;5;202m42\027[0m\027[38;5;240m, \027[0m\027[38;5;220mtrue\027[0m\027[38;5;240m, \027[0m\027[38;5;40m'\027[38;5;34mA\027[38;5;46m\\n\027[38;5;34mstring\027[38;5;40m'\027[0m \027[38;5;247m}\027[0m")

  end)

end)
