#!/usr/bin/ruby

require_relative 'datum'

while a = gets
    d = Datum.make_from_hex a
    puts d.to_base64
end
