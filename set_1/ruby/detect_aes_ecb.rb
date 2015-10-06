#!/usr/bin/ruby

require_relative 'crypto'
require 'base64'
require 'openssl'

while hex_digest = STDIN.gets
    cipher_text = Crypto.decode_hex(hex_digest)
    blocks = cipher_text.scan(/.{16}/m)
    #puts blocks
    if blocks.detect{ |e| blocks.count(e) > 1 }
        printf "The following hex encoded sting possibly uses AES in ECB mode" +
            "\n=============================================================\n" +
            hex_digest
    end
end

