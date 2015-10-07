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

end
