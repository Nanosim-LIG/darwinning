module Darwinning
  class Genotypes < Hash

    def initialize(*args)
      @hash == nil
      super
    end

    def genes
      return each_key.to_a
    end

    def hash
      @hash = super unless @hash
      return @hash
    end

  end
end
