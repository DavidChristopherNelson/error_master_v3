class DecoError < ApplicationRecord
  has_many :mappings, dependent: :destroy
  has_many :folders, through: :mappings
  belongs_to :filter

  def serialize
    serialized_form = {}
    attributes.each_key do |key|
      serialized_form[key.to_sym] = self[key]
    end
    serialized_form
  end

  def self.serialize
    serialized_form = []
    DecoError.all.find_each(batch_size: 1000) do |deco_error|
      serialized_form << deco_error.serialize
    end
    serialized_form
  end

  def self.serialize_group(deco_errors)
    deco_errors.to_a
    serialized_form = []
    deco_errors.each do |deco_error|
      serialized_form << deco_error.serialize
    end
    serialized_form
  end

  def self.display_info
    [
      {
        title: 'Error Information',
        contents:
              [
                { descriptor: 'Priority', field: :priority },
                { descriptor: 'Type', field: :error_type },
                { descriptor: 'Time of Occurrence', field: :date }
              ]
      },
      {
        title: 'HTTP Information',
        contents:
         [
           { descriptor: 'URL', field: :site_url },
           { descriptor: 'Controller', field: :controller },
           { descriptor: 'Action', field: :action },
           { descriptor: 'Hostname', field: :hostname },
           { descriptor: 'Remote IP', field: :remote_ip },
           { descriptor: 'Request ID', field: :request_id },
           { descriptor: 'Parameters', field: :parameters }
         ]
      },
      {
        title: 'Session Information',
        contents:
         [
           { descriptor: 'Session ID', field: :session_id },
           { descriptor: 'Rails Environment', field: :rails_env },
           { descriptor: 'Release', field: :release },
           { descriptor: 'Environment Variables', field: :environment_variables },
           { descriptor: 'Session Data', field: :session_data }
         ]
      },
      {
        title: 'Exception Information',
        contents:
         [
           { descriptor: 'Exception Class', field: :exception_class },
           { descriptor: 'Exception Message', field: :exception_message },
           { descriptor: 'Exception Stacktrace', field: :exception_stacktrace }
         ]
      }
    ]
  end
end
