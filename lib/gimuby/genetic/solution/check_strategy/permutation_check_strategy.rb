require 'gimuby/genetic/solution/check_strategy/check_strategy'

#
# Permutation goes represented as permutation from [0, ... l] indexes
class PermutationCheckStrategy < CheckStrategy

  def check(solution_representation)
    permutation = solution_representation
    expected_elements = *(0..permutation.length - 1)
    duplicate = []
    missing = []
    expected_elements.each do |element|
      match = permutation.select do |concreteElement|
        concreteElement == element
      end
      case match.length <=> 1
        when -1 then
          missing.push(element)
        when 1 then
          duplicate.push(element)
        else
          # do nothing
      end
    end
    missing.shuffle!
    duplicate.each do |to_remove|
      to_insert = missing.pop()
      ind = permutation.index(to_remove)
      permutation[ind] = to_insert
    end
    unless missing.empty?
      solution_representation = check(solution_representation)
    end
    solution_representation
  end

end