module ComputeLogic
  # Returns true if the filter matches the error and false otherwise.
  #
  # @params [hash] Error information containing all the keys rules make
  #                reference to. Some keys may be nil.
  # @params [hashes] Filter information containing an array of rules in
  #                  the key :rules
  def compute_match(error, filter)
    return false if filter[:rules] == []

    logic = format_logic(filter)
    rules = filter[:rules]
    logic = compute_logic(error, logic, rules)
  end

  # Returns the filter logic in the form of an array of rule ids and operators.
  #
  # @param [Hash] A hash containing filter information. Requires the :logic key
  # @return [Array of strings] Contains rule ids, '!', '&&', '||', '('' and ')'
  # ['91', '&&', '92', '&&', '93']
  def format_logic(filter)
    logic = filter[:logic]
    if logic.nil?
      logic = []
      filter[:rules].each do |rule|
        logic << rule['id'].to_s
        logic << '&&'
      end
      logic = logic[0..-2]
    else
      # This code turns logic from a string into an array.
      logic.gsub!(/[^\d()&|!]/, '')
      logic.gsub!(/(\d+)/, ',\1,')
      logic.gsub!(/(&&)/, ',\1,')
      logic.gsub!(/(\|\|)/, ',\1,')
      logic.gsub!(/(!)/, ',\1,')
      logic.gsub!(/(\()/, ',\1,')
      logic.gsub!(/(\))/, ',\1,')
      logic = logic[1..-2].split(',,')
    end
    logic
  end

  # Evaluates the boolean value of the logic.
  #
  # @params [hash] error Error information containing all the keys rules make
  #                      reference to. Some keys may be nil.
  # @params [array of strings] Logic data containing logic strings including
  #                            '!', '&&', '||', '('' and ')' and rule ids as
  #                            Integers.
  # @params [array of hashes] Each hash contains relevant data on each rule.
  # @return [Boolean] The boolean value of the logic.
  def compute_logic(error, logic, rules)
    logic = compute_brackets(error, logic, rules)
    logic = compute_rule_matches(error, logic, rules)
    logic = compute_not(logic)
    compute_and_or(logic)
  end

  # Evaluates the boolean value of the logic inside brackets. It performs a
  # recursive call to compute_logic()
  #
  # @params [hash] error Error information containing all the keys rules make
  #                      reference to. Some keys may be nil.
  # @params [array of strings] Logic data containing logic strings including
  #                            '!', '&&', '||', '('' and ')' and rule ids as
  #                            Integers.
  # @params [array of hashes] Each hash contains relevant data on each rule.
  # @return [Boolean] The boolean value of the logic inside brackets.
  def compute_brackets(error, logic, rules)
    logic.each_with_index do |element, start_index|
      next unless element == '('

      bracket_counter = 1
      logic[start_index + 1..].each_with_index do |element_inside_bracket, end_index|
        if element_inside_bracket == '('
          bracket_counter += 1
        elsif element_inside_bracket == ')'
          bracket_counter -= 1
        end
        next unless bracket_counter.zero?

        logic_subset = logic[start_index + 1..start_index + end_index]
        logic[start_index] = compute_logic(error, logic_subset, rules)
        logic.slice!(start_index + 1..start_index + end_index + 1)
        break
      end
    end
    logic
  end

  # Replaces the rule id in the logic array with the boolean value of its match
  #
  # @params [hash] Error information containing all the keys rules make
  #                reference to. Some keys may be nil.
  # @params [array of strings] Logic data containing logic strings including
  #                            '!', '&&' and '||' and rule ids as Integers.
  # @params [array of hashes] Each hash contains relevant data on each rule.
  # @return [array] All rule ids are replaced with boolean values.
  def compute_rule_matches(error, logic, rules)
    logic.map do |el|
      if /\d/.match?(el.to_s)
        rules.each do |rule|
          if rule['id'].to_s == el
            el = if error[rule['field']].nil?
                   false
                 elsif error[rule['field']].include?(rule['value'])
                   true
                 else
                   false
                 end
            break
          end
          el = false if rule == rules[-1] && ![true, false].include?(el)
        end
      end
      el
    end
  end

  # Returns a logic array with all not statements replaced by their boolean
  # value.
  #
  # @params [array of strings] Logic data containing logic strings including
  #                            '!', '&&' and '||'.
  # @return [array] All not statements are replaced with boolean values.
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

  # Returns a the boolean evaluation of the logic array.
  #
  # @params [array of strings] Logic data containing logic strings including
  #                            '&&' and '||'.
  # @return [boolean] The boolean evalution of the logic array
  def compute_and_or(logic)
    return_boolean = logic[0]
    logic.each_with_index do |el, index|
      if el == '&&'
        return_boolean &&= logic[index + 1]
      elsif el == '||'
        return_boolean ||= logic[index + 1]
      end
    end
    return_boolean
  end
end
