#!/usr/bin/ruby

require_relative 'crypto'
require 'base64'
require 'matrix'

#key = ARGV[0]
input = ''
while i = STDIN.gets
    input += i
end
input = input.strip

def get_hamming_score(blocks)
    scores = []
    block_size = blocks.first.length
    blocks.each_slice(2) do |b|
        if b[0] && b[1] && b[0].length == b[1].length
            scores << Crypto.hamming_distance(b[0], b[1]).to_f / block_size
        end
    end
    return scores.inject(:+).to_f / scores.length
end

cipher_text = Base64.decode64(input)
block_dists = Hash.new
for i in 2..(input.length * 0.025)
    blocks = cipher_text.scan(/.{#{i}}/m)
    score = get_hamming_score(blocks).to_f
    block_dists[i] = score
end
block_dists = Hash[block_dists.sort_by { |i, v| v }]

#printf("Testing block sizes: ")
#block_dists.keys.first(5).each do |i|
    #printf("%d ", i)
#end
#printf("\n")

best_plaintext = ''
best_score = 0
best_key = ''
block_dists.keys.first(5).each do |i|
    blocks = cipher_text.scan(/.{#{i}}/m)
    matrix = Matrix.rows(blocks.map { |s| s.split('') }).transpose
    key = ''
    matrix.to_a.each do |block|
        hexified = Crypto.encode_string_to_hex(block.join)
        k, r = Crypto.break_single_byte_xor(hexified)
        key += k.chr
    end
    repeated_key = Crypto.make_repeating_key(key, input.length)
    plaintext = Crypto.decode_hex Crypto.xor_raw_strings(cipher_text, repeated_key)
    score = Crypto.score_english(plaintext)
    if score > best_score
        best_score = score
        best_plaintext = plaintext
        best_key = key
    end
end
printf "Key(%d):\n%s\n", best_key.length, best_key
printf "=" * 32 + "\n"
printf "Plaintext(%f):\n%s\n", best_score, best_plaintext
