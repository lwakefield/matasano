require 'matrix'

class Datum

    def initialize(bytes)
        @bytes = bytes
    end

    def self.make_from_bytes(bytes)
        return Datum.new bytes
    end

    def self.make_from_string(str)
        return Datum.new str.bytes
    end

    def self.make_from_hex(str)
        return Datum.new [str.strip].pack('H*').bytes
    end

    def self.make_from_base64(str)
        return Datum.new str.unpack('m0').first.bytes
    end

    def split_into_blocks(size)
        blocks = @bytes.each_slice(size).to_a
        return blocks.map { |b| Datum.make_from_bytes b}
    end

    def split_into_blocks_and_transpose(size)
        target_size = size * (self.length.to_f / size).ceil
        padded_bytes = @bytes + [0]*(target_size - self.length)
        blocks = padded_bytes.each_slice(size).to_a
        blocks = Matrix.rows(blocks).transpose.to_a
        return blocks.map { |b| Datum.make_from_bytes b}
    end

    def length
        return @bytes.length
    end

    def to_bytes
        return @bytes
    end

    def to_s
        return @bytes.pack 'c*'
    end

    def to_binary
        return @bytes.map{ |b| sprintf("%b", b) }.join
    end

    def to_hex
        return @bytes.map{ |b| sprintf("%02x", b) }.join
    end

    def to_base64
        return [self.to_s].pack 'm0'
    end

end
