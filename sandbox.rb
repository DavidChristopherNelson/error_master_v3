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
  sql_return_value = DecoError.connection.query(sql_string)
  puts '====================================================================================='
  p sql_return_value
  puts '====================================================================================='

end


heroku pg:reset DATABASE_URL --app immense-eyrie-70341
heroku run rake db:migrate --app immense-eyrie-70341
heroku run rake db:seed --app immense-eyrie-70341



    params = { body: 
             { json: 
             { title: deco_error.title,
               priority: deco_error.priority,
               error_type: deco_error.error_type,
               date: deco_error.date,
               site_url: deco_error.site_url,
               controller: deco_error.controller,
               action: deco_error.action,
               hostname: deco_error.hostname,
               remote_ip: deco_error.remote_ip,
               request_id: deco_error.request_id,
               request_log: deco_error.request_log,
               parameters: deco_error.parameters,
               session_id: deco_error.session_id,
               rails_env: deco_error.rails_env,
               release: deco_error.release,
               environment_variables: deco_error.environment_variables,
               session_data: deco_error.session_data,
               exception_class: deco_error.exception_class,
               exception_message: deco_error.exception_message,
               exception_stacktrace: deco_error.exception_stacktrace
               } } }
