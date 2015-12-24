module Darwinning
  module EvolutionTypes

    class MutativeReproduction
      include ReExpress
      include Mutate
      attr_reader :mutation_rate

      def initialize(options = {})
        @mutation_rate = options.fetch(:mutation_rate, 0.1)
      end

      def pairwise?
        true
      end

      def evolve(*parents)
        raise "Only organisms of the same type can breed" unless parents.collect(&:class).uniq.length == 1
        new_member = random_selection(*parents)
        rand < mutation_rate ? mutate(new_member) : new_member
      end

      protected

      def random_selection(*parents)
        genotypes = Genotypes::new
        parents.first.genes.each { |gene|
          parent = parents.sample
          genotypes[gene] = parent.genotypes[gene]
        }
        return new_member_from_genotypes(parents.first.class, genotypes)
      end

    end

  end
end
