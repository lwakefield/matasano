#!/usr/bin/ruby

require_relative 'crypto'
require 'base64'
require 'openssl'

key = ARGV[0]
input = ''
while i = STDIN.gets
    input += i
end
input = input.strip

cipher_text = Base64.decode64(input)
decipher = OpenSSL::Cipher.new('aes-128-ecb')
decipher.decrypt 
decipher.key = key
plaintext = decipher.update(cipher_text) + decipher.final
puts plaintext
