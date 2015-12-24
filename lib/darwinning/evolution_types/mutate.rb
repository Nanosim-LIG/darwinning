module Darwinning
  module EvolutionTypes
    module Mutate
      protected
      def mutate(m)
        genotypes = m.genotypes.clone
        #gene selection should be done with a probability that
        #depend on the quantity of information they contain
        total_information_quantity = m.genes.inject(0) { |sum, g| sum += Math.log(g.versions, 2) }
        normalized_probabilities = m.genes.collect{ |g| [Math.log(g.versions, 2)/total_information_quantity, g] }.sort{ |e1,e2| e1[0] <=> e2[0]  }.reverse
        normalized_cumulative_probabilities = []
        normalized_cumulative_probabilities[0] = normalized_probabilities[0][0]
        (1...normalized_probabilities.length).each { |i|
          normalized_cumulative_probabilities[i] = normalized_cumulative_probabilities[i-1] + normalized_probabilities[i][0]
        }
        normalized_cumulative_probabilities[-1] = 1.0
        cut = rand
        gene = normalized_probabilities[normalized_cumulative_probabilities.find_index { |e| cut < e }][1]
        genotypes[gene] = gene.express
        return new_member_from_genotypes(m.class, genotypes)
      end
    end
  end
end
