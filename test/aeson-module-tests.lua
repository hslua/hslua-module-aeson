local aeson = require 'aeson'

assert(aeson.encode 'a string' == '"a string"')
assert(aeson.encode { foo = 5 } == '{"foo":5}' )
assert(aeson.encode {1, 1, 2, 3, 5} == '[1,1,2,3,5]' )

assert(aeson.decode '"Guten Tag"' == 'Guten Tag')
assert((aeson.decode '{"hello":"world"}')['hello'] == 'world')
