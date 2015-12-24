module Darwinning
  module EvolutionTypes
    class Mutation
      include ReExpress
      include Mutate
      attr_reader :mutation_rate

      def initialize(options = {})
        @mutation_rate = options.fetch(:mutation_rate, 0.0)
      end

      def evolve(members)
        members.map do |member|
          if rand < mutation_rate
            mutate(member)
          else
            member
          end
        end
      end

      def pairwise?
        false
      end

    end

  end
end
