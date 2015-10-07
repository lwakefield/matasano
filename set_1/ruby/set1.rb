#!/usr/bin/ruby

require_relative "crypto"
require "test/unit"

class TestSetOne < Test::Unit::TestCase

    def test_challenge_one
        d = Datum.make_from_hex '49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d'
        assert_equal d.to_base64, 'SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t'
    end

    def test_challenge_two
        a = Datum.make_from_hex '1c0111001f010100061a024b53535009181c'
        b = Datum.make_from_hex '686974207468652062756c6c277320657965'
        xored = Crypto.xor a, b
        assert_equal xored.to_hex, '746865206b696420646f6e277420706c6179'
    end

    def test_challenge_three
        cipher_text = Datum.make_from_hex '1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736'
        _, plaintext = Crypto.break_single_byte_xor cipher_text
        assert_equal plaintext.to_s, "Cooking MC's like a pound of bacon"
    end

    def test_challenge_four
        file = File.open('4.txt', 'r')
        data = file.read
        file.close

        cipher_texts = data.split("\n").map{ |c| Datum.make_from_hex c }
        _, plaintext = Crypto.detect_single_byte_xor cipher_texts
        assert_equal plaintext.to_s, "Now that the party is jumping\n"
    end

    def test_challenge_five
        plaintext = Datum.make_from_string "Burning 'em, if you ain't quick and nimble\n" + 
            "I go crazy when I hear a cymbal"
        key = Util.make_repeating_key 'ICE', plaintext.length
        cipher_text = Crypto.xor plaintext, key
        assert_equal cipher_text.to_hex, "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272" +
            "a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"
    end

    def test_challenge_six
        file = File.open('6.txt', 'r')
        data = ''
        file.each_line do |line|
            data += line.strip
        end
        file.close

        cipher_text = Datum.make_from_base64 data
        _, key = Crypto.break_repeating_key_xor cipher_text, 50
        assert_equal key.to_s, "Terminator X: Bring the noise"
    end

    def test_challenge_seven
        file = File.open('7.txt', 'r')
        data = ''
        file.each_line do |line|
            data += line.strip
        end
        file.close

        cipher_text = Datum.make_from_base64 data
        decipher = OpenSSL::Cipher.new('aes-128-ecb')
        decipher.decrypt 
        decipher.key = 'YELLOW SUBMARINE'
        plaintext = decipher.update(cipher_text.to_s) + decipher.final
        assert_equal Crypto.score_english(plaintext) > 1000, true
    end

    def test_challenge_eight
        file = File.open('8.txt', 'r')
        found = ''
        file.each_line do |line|
            ciphertext = Datum.make_from_hex line.strip
            if Crypto.detect_aes_ecb ciphertext, 16
                found = ciphertext
            end
        end
        file.close
        assert_equal found.to_hex, 'd880619740a8a19b7840a8a31c810a3d08649af70dc06f4fd5d2d69c744cd283e2dd052f6b641dbf9d11b0348542bb5708649af70dc06f4fd5d2d69c744cd2839475c9dfdbc1d46597949d9c7e82bf5a08649af70dc06f4fd5d2d69c744cd28397a93eab8d6aecd566489154789a6b0308649af70dc06f4fd5d2d69c744cd283d403180c98c8f6db1f2a3f9c4040deb0ab51b29933f2c123c58386b06fba186a'
    end

end
