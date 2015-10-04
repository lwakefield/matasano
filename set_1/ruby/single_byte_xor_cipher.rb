#!/usr/bin/ruby

def decode_hex(hex_digest)
    return [hex_digest.strip].pack('H*')
end

def xor_hex(hex_digest, key)
    return sprintf('%x', hex_digest.hex ^ key.hex)
end

def get_char_counts(plaintext)
    counts = Hash.new
    plaintext.each_char do |c|
        if !counts.has_key?(c)
            counts[c] = 1
        else
            counts[c] += 1
        end
    end
    return counts
end


def get_char_freq(plaintext)
    char_counts = get_char_counts(plaintext)
    char_freq = Hash.new
    char_counts.each do |i, val|
        char_freq[i] = val.to_f / plaintext.length
    end
    return char_freq
end

def score(char_freqs)
    target = { "e" => 0.1202, "t" => 0.0910, "a" => 0.0812, "o" => 0.0768, "i" => 0.0731, "n" => 0.0695, "s" => 0.0628, "r" => 0.0602, "h" => 0.0592, "d" => 0.0432, "l" => 0.0398, "u" => 0.0288, "c" => 0.0271, "m" => 0.0261, "f" => 0.0230, "y" => 0.0211, "w" => 0.0209, "g" => 0.0203, "p" => 0.0182, "b" => 0.0149, "v" => 0.0111, "k" => 0.0069, "x" => 0.0017, "q" => 0.0011, "j" => 0.0010, "z" => 0.0007, }
    error = 0
    target.each do |c, val|
        #printf(c)
        if char_freqs.has_key?(c)
            error += (val - char_freqs[c.downcase]) ** 2
        else
            error += val ** 2
        end
    end
    return error
    #return char_freqs.keys.join.scan(/[ETAOIN SHRDLU]/i).size
end

while hex_digest = gets
    (0..255).each do |i|
        key = i.to_s(16) * (hex_digest.length / 2)
        xored = xor_hex(hex_digest, key)
        plaintext = decode_hex(xored)
        char_freqs = get_char_freq(plaintext)
        score = score(char_freqs)
        if score < 0.04
            printf("Possible plaintext with score %f: %s\n", score, plaintext)
        end

        #puts decode_hex(xored)
    end
end
