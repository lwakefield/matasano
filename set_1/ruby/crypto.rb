class Crypto

    def self.decode_hex(hex_digest)
        return [hex_digest.strip].pack('H*')
    end

    def self.encode_base64(plaintext)
        return [plaintext].pack("m0")
    end

    def self.xor_strings(str_a, str_b)
        return str_a.bytes.zip(str_b.bytes).map{ |a,b| sprintf("%02x", (a ^ b)) }.join
    end

end
