#!/usr/bin/ruby

def decode_hex(hex_digest)
    return [[hex_digest.strip].pack('H*')]
end

def encode_base64(raw)
    return raw.pack("m0")
end

while a = gets
    puts encode_base64 decode_hex a
end
