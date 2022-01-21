require 'json'
# Setup default folder and filter structure.
all_folder = Folder.create!(name: 'All Errors',
                            user_created: false
                           )
uncategorized_folder = Folder.create!(name: 'Uncategorized',
                                      user_created: false
                                     )
uncategorized_filter = Filter.create!(folder_id: 2,
                                      name: 'Uncategorized filter',
                                      execution_order: 0
                                     )
Folder.create!(name: 'Ignore',
               user_created: false
              )
Filter.create!(folder_id: 3,
               name: 'Ignore filter',
               execution_order: 1
              )

# Setup 100 sample errors.
Dir['*/errors/*'].each do |path|
  error_data = JSON.parse(File.read(path))
  exception_data = (error_data['exception'].nil? ? {} : error_data['exception'])
  new_error = DecoError.create!(read: false,
                                title: error_data['title'],
                                priority: error_data['priority'],
                                error_type: error_data['type'],
                                date: error_data['date'],
                                site_url: error_data['site_url'],
                                controller: error_data['controller'],
                                action: error_data['action'],
                                hostname: error_data['hostname'],
                                remote_ip: error_data['remote_ip'],
                                request_id: error_data['request_id'],
                                request_log: error_data['request_log'],
                                parameters: error_data['params'],
                                session_id: error_data['session_id'],
                                rails_env: error_data['rails_env'],
                                release: error_data['release'],
                                environment_variables: error_data['environment_variables'],
                                session_data: error_data['session_data'],
                                exception_class: exception_data['class'],
                                exception_message: exception_data['message'],
                                exception_stacktrace: exception_data['stacktrace'],
                                filter_id: 1
                               )
  new_error.folders << uncategorized_folder
  new_error.folders << all_folder
  new_error.filter = uncategorized_filter
  Rails.logger.info("Added error #{new_error.title}")
end
