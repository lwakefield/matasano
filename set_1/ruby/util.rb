require_relative 'datum'

class Util

    def self.make_repeating_key(key, len)
        repeated_key = key * (len.to_f / key.length).ceil
        repeated_key = repeated_key.chars.first(len).join
        return Datum.make_from_string repeated_key
    end

end
