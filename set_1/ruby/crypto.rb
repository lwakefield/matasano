require_relative 'datum'
require_relative 'util'
require 'openssl'

class Crypto

    def self.detect_aes_ecb(ciphertext, size)
        blocks = ciphertext.to_s.scan(/.{#{size}}/m)
        return blocks.detect{ |e| blocks.count(e) > 1 }
    end

    def self.xor(a, b)
        a_bytes = a.to_bytes
        b_bytes = b.to_bytes
        raise "XOR inputs must have the same length" unless a_bytes.length == b_bytes.length

        xored = a_bytes.zip(b_bytes).map {|i, j| i ^ j}
        return Datum.make_from_bytes xored
    end

    def self.break_repeating_key_xor(cipher_text, max_key_size)
        block_dists = Hash.new
        for i in 2..max_key_size
            blocks = cipher_text.split_into_blocks i
            score = self.hamming_score(blocks).to_f
            block_dists[i] = score
        end
        block_dists = Hash[block_dists.sort_by { |i, v| v }]

        best_plaintext = ''
        best_score = 0
        best_key = ''
        block_dists.keys.first(5).each do |i|
            blocks = cipher_text.split_into_blocks_and_transpose i
            key = ''
            blocks.to_a.each do |block|
                k, _ = Crypto.break_single_byte_xor block
                key += k.to_s[0]
            end
            repeated_key = Util.make_repeating_key(key, cipher_text.length)
            plaintext = Crypto.xor repeated_key, cipher_text
            score = Crypto.score_english(plaintext)
            if score > best_score
                best_score = score
                best_plaintext = plaintext
                best_key = key
            end
        end
        return best_plaintext, best_key
    end

    def self.hamming_score(blocks)
        scores = []
        block_size = blocks.first.length
        blocks.each_slice(2) do |b|
            if b[0] && b[1] && b[0].length == b[1].length
                scores << Crypto.hamming_distance(b[0], b[1]).to_f / block_size
            end
        end
        return scores.inject(:+).to_f / scores.length
    end

    def self.hamming_distance(block_a, block_b)
        xored = self.xor block_a, block_b
        return xored.to_binary.scan(/[1]/).size
    end

    def self.detect_single_byte_xor(cipher_texts)
        top_score = 0
        top_soln = ''
        top_key = ''
        cipher_texts.each do |cipher_text|
            key, plaintext = Crypto.break_single_byte_xor cipher_text
            score = Crypto.score_english(plaintext)
            if score > top_score
                top_score = score
                top_soln = plaintext
                top_key = key
            end
        end
        return top_key, top_soln
    end

    def self.break_single_byte_xor(cipher_text)
        top_score = 0
        top_soln = ''
        top_key = ''
        (0..255).each do |i|
            key = Datum.make_from_bytes [i]*cipher_text.length
            xored = Crypto.xor cipher_text, key
            score = Crypto.score_english(xored)
            if score > top_score
                top_score = score
                top_soln = xored
                top_key = key
            end
        end
        return top_key, top_soln
    end

    def self.score_english(plaintext)
        plaintext_str = plaintext.to_s
        alpha_count = plaintext_str.scan(/[a-z]/i).size
        score =  plaintext_str.scan(/[eaton shrldu]/i).size
        return (alpha_count * score).to_f / plaintext_str.length
    end

end
