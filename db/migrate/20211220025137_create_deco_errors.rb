class CreateDecoErrors < ActiveRecord::Migration[6.1]
  def change
    create_table :deco_errors do |t|
      t.text :title
      t.boolean :read
      t.text :priority
      t.text :error_type
      t.text :date
      t.text :site_url
      t.text :controller
      t.text :action
      t.text :hostname
      t.text :remote_ip
      t.text :request_id
      t.text :request_log
      t.text :parameters
      t.text :session_id
      t.text :rails_env
      t.text :release
      t.text :environment_variables
      t.text :session_data
      t.text :exception_class
      t.text :exception_message
      t.text :exception_stacktrace
      t.references :filter, null: false, foreign_key: true
      t.timestamps
    end
  end
end
