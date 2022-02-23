sql_rule_command = 'SELECT rules.filter_id, rules.id, rules.field, rules.value
FROM filters
INNER JOIN rules
ON filters.id = rules.filter_id'
puts '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
puts sql_rule_command
puts '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'

rule_data = Rule.connection.execute(sql_rule_command)