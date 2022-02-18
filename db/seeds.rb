require 'json'

def time_it(experiment_name)
  # Delete this method. Created 1/2/22. Only intended for experimental purposes.
  time_before = Time.now
  yield if block_given?
  time_after = Time.now
  puts('======================================================================')
  puts("It took #{time_after - time_before} seconds to run #{experiment_name}.")
end

# The json object received from DecoNetwork's systems has slightly different
# key names compared to Error Master's database and this method fixes that.
#
# @param [hash] The json object received from DecoNetwork's systems.
# @return [hash] Error information with keys that match the database column
#                names.
def standardise_field_names(error)
  error['filter_id'] = '1'
  error['folder_id'] = '1'
  error['created_at'] = '2022-02-09'
  error['updated_at'] = '2022-02-09'
  error['error_type'] = error['type']
  error['parameters'] = error['params']
  error['read'] = false
  unless error['exception'].nil?
    error['exception_class'] = error['exception']['class']
    error['exception_message'] = error['exception']['message']
    error['exception_stacktrace'] = error['exception']['stacktrace']
  end
end

# Setup default folder and filter structure.
Folder.create(name: 'Uncategorized',
              user_created: false
             )
Filter.create(folder_id: 1,
              name: 'Uncategorized filter',
              execution_order: 0
             )
Folder.create(name: 'Ignore',
              user_created: false
             )
Filter.create(folder_id: 2,
              name: 'Ignore filter',
              execution_order: 1
             )

Folder.create(name: 'Bad descript',
              user_created: true
             )
Filter.create(folder_id: 3,
              name: 'Bad descript filter group',
              execution_order: 3
             )
Rule.create(field: 'title',
            filter_id: 3,
            value: 'Bad file descriptor'
           )

Folder.create(name: 'Bad home descript',
              user_created: true,
              parent_id: 3
             )
Filter.create(folder_id: 4,
              name: 'Bad home descript filter group',
              execution_order: 2
             )
Rule.create(field: 'title',
            filter_id: 4,
            value: 'Bad file descriptor'
           )
Rule.create(field: 'title',
            filter_id: 4,
            value: 'home'
           )

# Setup 100 folders
98.times do |loop_number|
  Folder.create(name: (0...8).map { rand(65..90).chr }.join,
                user_created: true,
                parent_id: rand(1..loop_number - 1)
               )
end

# Setup 100 filters with 3 rules each
fields = %i[title priority request_id remote_ip controller action]
98.times do |loop_number|
  filter = Filter.create(folder_id: rand(1..2),
                         name: (0...8).map { rand(65..90).chr }.join,
                         execution_order: loop_number + 2
                        )
  3.times do |_|
    Rule.create(filter_id: filter.id,
                field: fields.sample,
                value: (0...8).map { rand(65..90).chr }.join
               )
  end
end

# Setup 10,000 errors
error_data = []
Dir['*/errors/*'].each do |path|
  error_data << JSON.parse(File.read(path))
end
fields = DecoError.attribute_names[1..-1]

100.times do |iteration|
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
    "VALUES #{bulk_insert.join(', ')}"
  DecoError.connection.query(sql_string)
  p iteration
end
