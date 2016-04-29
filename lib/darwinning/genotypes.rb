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

    def []=(*args)
      @hash = nil
      super
    end

    def valid?(search_space)
      h = {}
      a = []
      genes.each{ |g|
        h[g.name.to_sym] = self[g]
      }
      a.push h
      search_space.remove_unfeasible a if not search_space.rules.nil?
      if not a.empty?
        return true
      else
        return false
      end
    end
  end
end
