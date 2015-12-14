module Darwinning
  module EvolutionTypes

    class MutativeReproduction
      include ReExpress
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
        return mutate(new_member)
      end

      protected

      def random_selection(*parents)
        genotypes = {}
        parents.first.genes.each { |gene|
          parent = parents.sample
          genotypes[gene] = parent.genotypes[gene]
        }
        return new_member_from_genotypes(parents.first.class, genotypes)
      end

      def mutate(m)
        return m unless rand < mutation_rate
        genotypes = m.genotypes
        random_index = rand(m.genotypes.length - 1)
        gene = m.genes[random_index]
        genotypes[gene] = gene.express
        return new_member_from_genotypes(m.class, genotypes)
      end

    end

  end
end
