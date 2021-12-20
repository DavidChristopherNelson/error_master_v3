require 'json'
#Setup default folder and filter structure.
uncategorised_folder = Folder.create(name: "Uncategorised")
Filter.create(folder_id: 1,
              name: "Uncategorised filter group",
              execution_order: 0)
              
Folder.create(name: "Ignore")
Filter.create(folder_id: 2,
              name: "Ignore filter group",
              execution_order: 1)

Folder.create(name: "Bad descript")
Filter.create(folder_id: 3,
              name: "Bad descript filter group",
              execution_order: 3)
Rule.create(field: "title",
            filter_id: 3,
            value: "Bad file descriptor")

Folder.create(name: "Bad home descript",
              parent_id: 3)
Filter.create(folder_id: 4,
              name: "Bad home descript filter group",
              execution_order: 2)
Rule.create(field: "title",
            filter_id: 4,
            value: "Bad file descriptor")
Rule.create(field: "title",
            filter_id: 4,
            value: "home")

#Setup 100 sample errors.
Dir["*/errors/*"].each do |path|
  puts path
  error_data = JSON.parse(File.read(path))
  exception_data = (error_data["exception"] == nil ? {} : error_data["exception"])
  new_error = DecoError.create(read: false,
               title: error_data["title"],
               priority: error_data["priority"],
               error_type: error_data["type"],
               date: error_data["date"],
               site_url: error_data["site_url"],
               controller: error_data["controller"],
               action: error_data["action"],
               hostname: error_data["hostname"],
               remote_ip: error_data["remote_ip"],
               request_id: error_data["request_id"],
               request_log: error_data["request_log"],
               parameters: error_data["params"],
               session_id: error_data["session_id"],
               rails_env: error_data["rails_env"],
               release: error_data["release"],
               environment_variables: error_data["environment_variables"],
               session_data: error_data["session_data"],
               exception_class: exception_data["class"],
               exception_message: exception_data["message"],
               exception_stacktrace: exception_data["stacktrace"],
               filter_id: 1)
  new_error.folders << uncategorised_folder
end
