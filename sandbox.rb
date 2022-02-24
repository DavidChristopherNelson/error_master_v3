error_data = []
Dir['*/errors/*'].each do |path|
 error_data << JSON.parse(File.read(path))
end
time_it("SQL insert of 1000 errors") do |_|
  fields = DecoError.attribute_names[1..-1]

  10.times do |_|
    bulk_insert = []
    error_data.each do |error|
      values = []
      standardise_field_names(error)
      fields.each do |field|
        values << DecoError.connection.quote(error[field])
      end
      bulk_insert << "(#{values.join(',')})"
    end
    sql_string = "INSERT INTO deco_errors(#{fields.join(',')}) " +
                 "VALUES #{bulk_insert.join(", ")}"
    DecoError.connection.query(sql_string)
  end
end

excluded_fields = %w[id filter_id created_at updated_at]
if
else
	error_fields_and_values = {
		'filter_id' => 1,
		'folder_id' => 1
	}
	params['json'].each do |pair|
		next if pair[1].nil? || pair[1] == ''
		next if excluded_fields.include?(pair[0])
		error_fields_and_values[pair[0]] = pair[1]
	end
	sql_string = "INSERT INTO deco_errors(#{error_fields_and_values.keys.join(', ')}) " +
               "VALUES #{error_fields_and_values.values.join(', ')}"
  DecoError.connection.query(sql_string)
end