require 'darwinning'
require 'pp'

class Triple
  include Darwinning

  GENE_RANGES = {
    first_number: (0..100),
    second_number: (0..100),
    third_number: (0..100)
  }

  attr_accessor :first_number, :second_number, :third_number

  def fitness
    # Try to get the sum of the 3 digits to add up to 100
    return @fitness if defined?(@fitness)
    @fitness = (first_number + second_number + third_number - 100).abs
  end

  def to_s
    "< first_number: #{"%3d" % first_number}, second_number: #{"%3d" % second_number}, third_number: #{"%3d" % third_number}, fitness: #{"%3d" % fitness} >"
  end
end

if Triple.is_evolveable?
  triple_pop = Triple.build_population(0, 10, 100, [Darwinning::EvolutionTypes::MutativeReproduction.new(mutation_rate: 0.10) ])
  triple_pop.evolve! # create new generations until fitness goal is met or generation limit is met

  puts "Solution"
  puts "========"
  puts "generation number: #{triple_pop.generation}"
  puts "best member fitness: #{triple_pop.best_member.fitness}"
  puts "best member:"
  puts triple_pop.best_member
  if triple_pop.best_member.fitness > 0 then
    puts triple_pop.members
  end
end
