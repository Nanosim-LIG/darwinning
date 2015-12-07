module Darwinning
  module EvolutionTypes
    module ReExpress
      def new_member_from_genotypes(organism_klass, genotypes)
        new_member = organism_klass.new
        if organism_klass < Darwinning::Organism
          new_member.genotypes = genotypes
        else
          new_member.genes.each do |gene|
            new_member.send("#{gene.name}=", genotypes[gene])
          end
        end
        new_member
      end
    end
  end
end
