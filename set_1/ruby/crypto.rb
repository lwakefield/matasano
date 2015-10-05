class Crypto

    def self.decode_hex(hex_digest)
        return [hex_digest.strip].pack('H*')
    end

    def self.encode_base64(plaintext)
        return [plaintext].pack("m0")
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
        xored = self.xor_raw_strings(str_a, str_b)
        puts xored.to_s(2)
    end

end
