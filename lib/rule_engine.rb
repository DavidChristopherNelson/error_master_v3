# At some point I'll put this code into the DecoError, Filter and Rule models.

module RuleEngine
  # Returns the relevant error and filter data needed to process the rule
  # engine for the given resource.
  #
  # @param [hash] provides resource information. Two keys; :controller and :id.
  #               {controller: "filters", id: 33}
  # @option :controller must be either "filter", "folder" or "deco_error"
  # @return [array] returns error and filter data. First element contains error
  #                 data and the second element contains filter data.
  def get_error_and_filter_data(resource)
    # parameter checking
    raise(ArguementError, 'Argument must have :controller key.') if resource['controller'].nil?

    unless resource['controller'] == 'folders' || resource['controller'] == 'filters'
      raise(ArgumentError,
            "Argument :controller key must be either 'folders' or 'filters' " +
              "instead it is #{resource['controller']}"
           )
    end
    unless resource['id'].instance_of?(Integer)
      raise(ArgumentError, 'Argument :id key must have an Integer value. ' +
        "Instead it is #{resource['id'].class}"
      )
    end

   # get filter data
    filter_data = hit_filter_cache
 
    if resource['controller'] == 'filters'
      after_filter_of_interest = false
      filter_data.select! do |filter|
        after_filter_of_interest = true if filter['id'] == resource['id']
        after_filter_of_interest
      end
    end

    # get error data
    error_data = []
    case resource['controller']
    when 'folders'

      sql_statement = "SELECT #{get_rule_fields.join(', ')}, id " +
        'FROM deco_errors ' +
        "WHERE folder_id = #{resource['id']}"
      error_data = DecoError.connection.execute(sql_statement).to_a
    when 'filters'
      filter_ids = []
      filter_data.each { |filter| filter_ids << filter['id'] }
      # Add the uncategorized filter to the id array.
      filter_ids << 1 unless filter_ids.include?(1)
      sql_statement = "SELECT #{get_rule_fields.join(', ')}, id " +
        'FROM deco_errors ' +
        'WHERE filter_id ' +
        "IN (#{filter_ids.join(', ')})"
      error_data = DecoError.connection.execute(sql_statement).to_a
    end

    # return data
    [error_data, filter_data]
  end

  # Returns the fields that all the rules make reference to.
  #
  # @return [array of strings] An array of all field names. Format below.
  # ["remote_ip", "title", "priority", "action", "request_id", "controller"]
  def get_rule_fields
    rule_data = hit_rule_cache
    rule_fields = []
    rule_data.each do |rule|
      rule_fields << rule['field'] unless rule_fields.include?(rule['field'])
    end
    # Unfortunately a few column names are reserved SQL keywords.
    rule_fields.map do |field|
      field = "\"#{field}\"" if %w[action read date parameters release].include?(field)
      field
    end
  end

  # Returns the filter information that is stored in the cache. It reseeds the
  # cache in the event of a cache miss.
  #
  # @return [Array of Hashes] The rule data stored in the database. Format
  #                           below. List of keys: "id", "logic", :rules.
  # {"id"=>42, "logic"=>nil, :rules=>[{"filter_id"=>42, "logic"=>nil,
  #  "id"=>118, "field"=>"action", "value"=>"JESOLXIR"}, {"filter_id"=>42,
  #  "logic"=>nil, "id"=>119, "field"=>"priority", "value"=>"YIUQTGZJ"},
  #  {"filter_id"=>42, "logic"=>nil, "id"=>120, "field"=>"controller",
  #  "value"=>"UUYKDOTL"}] ... }
  def hit_filter_cache
    return_value = Rails.cache.fetch(Filter.cache_key) do
      rule_data = hit_rule_cache
      sql_filter_command = 'SELECT filters.id, filters.logic, filters.folder_id ' +
                           'FROM filters ORDER BY filters.execution_order'
      filter_data = Filter.connection.execute(sql_filter_command).to_a

      filter_data.each { |filter| filter[:rules] = [] }

      rule_data.each do |rule|
        filter_data.each do |filter|
          filter[:rules]

          filter[:rules] << rule if filter['id'] == rule['filter_id']
        end
      end
      filter_data.to_a
    end

    return_value
  end

  # Returns the rule information that is stored in the cache. It reseeds the
  # cache in the event of a cache miss.
  #
  # @return [Array of Hashes] The rule data stored in the database.
  #                           Specifically every rule's filter_id, id, field
  #                           and value. Format example below.
  # [{"filter_id"=>100, "logic"=>nil, "id"=>293, "field"=>"priority",
  #   "value"=>"UZINJKJX"}, ...]
  def hit_rule_cache
    rule_data = Rails.cache.fetch(Rule.cache_key) do
      sql_rule_command = 'SELECT rules.filter_id, rules.id, rules.field, rules.value
                          FROM filters
                          INNER JOIN rules
                          ON filters.id = rules.filter_id'

      rule_data = Rule.connection.execute(sql_rule_command).to_a
    end
  end
end
