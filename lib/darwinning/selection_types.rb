module Darwinning
  module SelectionTypes

    module Sampling

      def compute_normalized_fitness(members)
        normalized_fitness = nil
        return members.collect { |m| [1.0/members.length, m] } if members.first.fitness == members.last.fitness
        if @fitness_objective == :nullify
          normalized_fitness = members.collect { |m| [ m.fitness.abs <= fitness_goal ? Float::INFINITY : 1.0/(m.fitness.abs - fitness_goal), m] }
        else
          if @fitness_objective == :maximize
            if fitness_goal == Float::INFINITY then
              #assume goal to be at twice the maximum distance between fitness
              goal = members.first.fitness + ( members.first.fitness - members.last.fitness )
            else
              goal = fitness_goal
            end
            normalized_fitness  = members.collect { |m| [ m.fitness >= goal ? Float::INFINITY : 1.0/(goal - m.fitness), m] }
          else
            if fitness_goal == -Float::INFINITY then
              goal = members.first.fitness - ( members.last.fitness - members.first.fitness )
            else
              goal = fitness_goal
            end
            normalized_fitness  = members.collect { |m| [ m.fitness <= goal ? Float::INFINITY : 1.0/(m.fitness - goal), m] }
          end
        end
        if normalized_fitness.first[0] == Float::INFINITY then
          normalized_fitness.collect! { |m|
            m[0] == Float::INFINITY ? [1.0, m[1]] : [0.0, m[1]]
          }
        end
        sum = normalized_fitness.collect(&:first).inject(0.0, :+)
        return normalized_fitness.collect { |m| [m[0]/sum, m[1]] }
      end

    end

    autoload :RouletteSampling,     'darwinning/selection_types/roulette_sampling'
  end
end
