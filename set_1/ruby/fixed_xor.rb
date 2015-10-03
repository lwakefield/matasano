#!/usr/bin/ruby

while a = gets
    inputs = a.split('^')
    xored = sprintf('%x', (inputs[0].hex ^ inputs[1].hex))
    puts xored
end

