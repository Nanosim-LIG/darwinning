# Found from http://www.railstips.org/blog/archives/2006/11/18/class-and-instance-variables-in-ruby/
module ClassLevelInheritableAttributes
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def inheritable_attributes(*args)
      @inheritable_attributes ||= [:inheritable_attributes]
      @inheritable_attributes += args
      args.each do |arg|
        class_eval %(
          class << self; attr_accessor :#{arg} end
        )
      end
      @inheritable_attributes
    end

    def inherited(subclass)
      @inheritable_attributes.each do |inheritable_attribute|
        instance_var = "@#{inheritable_attribute}"
        subclass.instance_variable_set(instance_var, instance_variable_get(instance_var))
      end
    end
  end
end

module Darwinning
  class Organism
    include ClassLevelInheritableAttributes
    inheritable_attributes :genes, :name
    attr_accessor :genotypes, :fitness

    @genes = []  # Gene instances
    @name = ""

    def initialize(genotypes = Genotypes::new)
      @genotypes = genotypes
      if @genotypes.empty?
        # fill genotypes with expressed Genes
        genes.each do |g|
          # make genotypes a hash with gene objects as keys
          @genotypes[g] = g.express
        end
      end

      @fitness = nil
    end

    def ==(o)
      self.class == o.class && self.genotypes == o.genotypes
    end

    alias eql? ==

    def hash
      return self.genotypes.hash
    end

    def name
      self.class.name
    end

    def genes
      self.class.genes
    end

    # Unsure the combination of genes for this organism
    # meets the constraints of the search space
    def valid?(search_space)
      a = []
      a.push self.to_a[0]
      search_space.remove_unfeasible a if not search_space.rules.nil?
      if not a.empty?
        return true
      else
        return false
      end
    end
  end

end
