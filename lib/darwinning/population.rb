module Darwinning
  class Population

    EPSILON = 0.01

    attr_reader :members, :generations_limit, :fitness_goal, :fitness_objective,
                :organism, :population_size, :generation, :elitism,
                :evolution_types, :history

    DEFAULT_EVOLUTION_TYPES = [
      Darwinning::EvolutionTypes::Reproduction.new(crossover_method: :alternating_swap),
      Darwinning::EvolutionTypes::Mutation.new(mutation_rate: 0.10)
    ]

    DEFAULT_SELECTION_TYPE = Darwinning::SelectionTypes::RouletteSampling

    def initialize(options = {})
      @organism = options.fetch(:organism)
      @population_size = options.fetch(:population_size)
      @fitness_objective = options.fetch(:fitness_objective, :nullify) # :maximize, :minimize
      @fitness_goal = options.fetch(:fitness_goal)
      @elitism = options.fetch(:elitism, 1)
      @twin_removal = options.fetch(:twin_removal, true)
      @generations_limit = options.fetch(:generations_limit, 0)
      @evolution_types = options.fetch(:evolution_types, DEFAULT_EVOLUTION_TYPES)
      @selection_type = options.fetch(:selection_types, DEFAULT_SELECTION_TYPE)
      @members = []
      @generation = 0 # initial population is generation 0
      @history = []
      @search_space = options.fetch(:search_space, nil)
      
      build_population(@population_size)
      sort_members
      @history << @members
      extend @selection_type
    end

    def twin_removal?
      return !!@twin_removal
    end

    def build_population(population_size)
      population_size.times do |i|
        if @search_space then
          begin
            new_member = build_member
          end until new_member.genotypes.valid?(@search_space)
        else
          new_member = build_member
        end
        @members << new_member
      end
    end

    def evolve!
      until evolution_over?
        make_next_generation!
      end
    end

    def set_members_fitness!(fitness_values)
      throw "Invaid number of fitness values for population size" if fitness_values.size != members.size
      members.to_enum.each_with_index { |m, i| m.fitness = fitness_values[i] }
      sort_members
    end

    def make_next_generation!
      new_members = @members[0...@elitism]

      until new_members.length >= members.length
        m1, m2 = select( @members, 2 )

        candidates = [apply_pairwise_evolutions(m1, m2)].flatten
        candidates.each { |c|
          new_members.push(c) unless twin_removal? and new_members.include?(c) or not c.genotypes.valid?(@search_space)
        }
      end
      
      @members = new_members[0...@elitism] + apply_non_pairwise_evolutions(new_members[@elitism..-1])
      sort_members
      @history << @members
      @generation += 1
    end

    def evolution_over?
      # check if the fitness goal or generation limit has been met
      if generations_limit > 0
        generation == generations_limit || goal_attained?
      else
        goal_attained?
      end
    end

    def best_member
      @members.first
    end

    def size
      @members.length
    end

    def organism_klass
      real_organism = @organism
      fitness_function = @fitness_function
      klass = Class.new(Darwinning::Organism) do
        @name = real_organism.name
        @genes = real_organism.genes
      end
    end

    private

    def goal_attained?
      case @fitness_objective
      when :nullify
        best_member.fitness.abs <= fitness_goal
      when :maximize
        best_member.fitness >= fitness_goal
      else
        best_member.fitness <= fitness_goal
      end
    end

    def sort_members
      case @fitness_objective
      when :nullify
        @members = @members.sort_by { |m| m.fitness ? m.fitness.abs : m.fitness }
      when :maximize
        @members = @members.sort_by { |m| m.fitness }.reverse
      else
        @members = @members.sort_by { |m| m.fitness }
      end
    end

    def build_member
      member = organism.new
      unless member.class < Darwinning::Organism
        member.class.genes.each do |gene|
          gene_expression = gene.express
          member.send("#{gene.name}=", gene_expression)
        end
      end
      member
    end

    def apply_pairwise_evolutions(m1, m2)
      evolution_types.inject([m1, m2]) do |ret, evolution_type|
        if evolution_type.pairwise?
          evolution_type.evolve(*ret)
        else
          ret
        end
      end
    end

    def apply_non_pairwise_evolutions(members)
      evolution_types.inject(members) do |ret, evolution_type|
        if evolution_type.pairwise?
          ret
        else
          evolution_type.evolve(ret)
        end
      end
    end

  end
end
