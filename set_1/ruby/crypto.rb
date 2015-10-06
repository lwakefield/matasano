class Crypto

    def self.decode_hex(hex_digest)
        return [hex_digest.strip].pack('H*')
    end

    def self.encode_string_to_hex(plaintext)
        return plaintext.bytes.map { |b| self.byte_to_hex_string(b) }.join
    end

    def self.encode_base64(plaintext)
        return [plaintext].pack("m0")
    end

    def self.decode_base64(base64_digest)
        return [base64_digest].unpack("m0")
    end

    def self.byte_to_hex_string(byte)
        return sprintf("%02x", byte)
    end

    def self.xor_raw_strings(str_a, str_b)
        return str_a.bytes.zip(str_b.bytes).map{ |a,b| sprintf("%02x", (a ^ b)) }.join
    end

    def self.xor_hex_strings(hex_a, hex_b)
        str_a = self.decode_hex(hex_a)
        str_b = self.decode_hex(hex_b)
        return self.xor_raw_strings(str_a, str_b)
    end

    def self.make_repeating_key(key, len)
        repeated_key = key * (len.to_f / key.length).ceil
        return repeated_key.chars.first(len).join
    end

    def self.score_english(plaintext)
        alpha_count = plaintext.scan(/[a-z]/i).size
        score =  plaintext.scan(/[eaton shrldu]/i).size
        return (alpha_count * score).to_f / plaintext.length
    end

    def self.hamming_distance(str_a, str_b)
        xored = str_a.bytes.zip(str_b.bytes).map{ |a,b| sprintf("%02b", a ^ b) }.join
        return xored.scan(/[1]/).size
    end

    def self.break_single_byte_xor(hex_digest)
        top_score = 0
        top_soln = ''
        top_key = -1
        (0..255).each do |i|
            key = self.byte_to_hex_string(i) * (hex_digest.length / 2)
            xored = self.xor_hex_strings(hex_digest, key)
            plaintext = self.decode_hex(xored)
            score = self.score_english(plaintext)
            if score > top_score
                top_score = score
                top_soln = plaintext
                top_key = i
            end
        end
        return top_key, top_soln
    end

end
