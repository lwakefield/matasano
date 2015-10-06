class Crypto

    def self.xor(a, b)
        a_bytes = a.to_bytes
        b_bytes = b.to_bytes
        raise "XOR inputs must have the same length" unless a_bytes.length == b_bytes.length

        xored = a_bytes.zip(b_bytes).map {|i, j| i ^ j}
        return Datum.make_from_bytes xored
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
