module Darwinning
  module EvolutionTypes
    module Mutate
      protected
      def mutate(m)
        genotypes = m.genotypes.clone
        random_index = rand(genotypes.length - 1)
        gene = m.genes[random_index]
        genotypes[gene] = gene.express
        return new_member_from_genotypes(m.class, genotypes)
      end
    end
  end
end
