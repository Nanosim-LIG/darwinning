module Darwinning
  module SelectionTypes
    module RouletteSampling
      include Sampling

      def select_different(members, number)
        raise "Not enough members!" if members.length < number
        candidates = []
        membs = members.dup
        number.times {
          c = select(membs, 1, false).first
          candidates.push(c)
          membs.delete(c)
        }
        return candidates
      end

      def select(members, number, different = true)
        return select_different(members, number) if different
        normalized_fitness = compute_normalized_fitness(members)
        normalized_cumulative_sums = []
        normalized_cumulative_sums[0] = normalized_fitness[0]
        (1...normalized_fitness.length).each { |i|
          normalized_cumulative_sums[i] = [ normalized_cumulative_sums[i-1][0] + normalized_fitness[i][0], normalized_fitness[i][1] ]
        }
        normalized_cumulative_sums.last[0] = 1.0
        candidates = []
        number.times { |i|
          cut = rand
          candidates.push( normalized_cumulative_sums.find { |e| cut < e[0] }[1] )
        }
        return candidates
      end

    end
  end
end
