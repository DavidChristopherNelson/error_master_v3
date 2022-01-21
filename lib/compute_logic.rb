module ComputeLogic
  def compute_match(deco_error, filter)
    return false if filter[:rules] == []

    logic = filter[:logic].dup
    rules = filter[:rules].dup
    compute_logic(deco_error, logic, rules)
  end

  private

  def compute_logic(deco_error, logic, rules)
    logic = compute_brackets(deco_error, logic, rules)
    logic = compute_rule_matches(deco_error, logic, rules)
    logic = compute_not(logic)
    compute_and_or(logic)
  end

  def compute_brackets(deco_error, logic, rules)
    logic.each_with_index do |element, start_index|
      next unless element == '('

      bracket_counter = 1
      logic[start_index + 1..].each_with_index do |element_inside_bracket, end_index|
        case element_inside_bracket
        when '('
          bracket_counter += 1
        when ')'
          bracket_counter -= 1
        else
        end
        next unless bracket_counter.zero?

        logic_subset = logic[start_index + 1..start_index + end_index]
        logic[start_index] = compute_logic(deco_error, logic_subset, rules)
        logic.slice!(start_index + 1..start_index + end_index + 1)
        break
      end
    end
    logic
  end

  def compute_rule_matches(deco_error, logic, rules)
    logic.map do |element|
      if /\d/.match?(element.to_s)
        rule = rules.find { |filter_rule| filter_rule[:id] == Integer(element, 10) }
        element = deco_error[rule[:field].to_sym].include?(rule[:value])
      else
      end
      element
    end
  end

  def compute_not(logic)
    return_logic = []
    logic.each_with_index do |element, index|
      if element == '!'
        logic[index + 1] = !logic[index + 1]
      else
        return_logic << element
      end
    end
    return_logic
  end

  def compute_and_or(logic)
    return_boolean = logic[0]
    logic.each_with_index do |element, index|
      next if !element.nil? == element

      case element
      when '&&'
        return_boolean &&= logic[index + 1]
      when '||'
        return_boolean ||= logic[index + 1]
      else
      end
    end
    return_boolean
  end
end
