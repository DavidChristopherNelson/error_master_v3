require 'json'
require 'pp'
require 'pry'
require "awesome_print"




  # Error data can contain fields that are strings which represent hashes. 
  # However, these strings might not follow JSON convention, for instance they 
  # might be generated from using Ruby’s .to_s method on a hash. This method 
  # tries a few common patterns to convert the string into a hash. 
  #
  # @param [string] the string to attempt to turn into a hash.
  # @return [hash or nil] the hash representation of the string or nil if the 
  #                       convertion was not achieved.
  def convert_string_to_hash(data_as_string)
    begin
      data_as_hash = JSON(data_as_string)
    rescue JSON::ParserError
      data_as_string[1..-2] = data_as_string[1..-2].gsub(/[\{]/, ' (open curly brace) ')
      data_as_string[1..-2] = data_as_string[1..-2].gsub(/[\}]/, ' (close curly brace) ')
      data_as_string.gsub!(/"/,"") # converts " into '
      data_as_string.gsub!(/([\:\w\-\/\']+)\=\>([\w\-\/\s\'\:\(\)\+\.]+)/, '"\1": "\2"')
      data_as_string.gsub!(/\n/, '')
      begin
        data_as_hash = JSON(data_as_string)
      rescue JSON::ParserError
        return nil
      else 
        return data_as_hash
      end
    else
      return data_as_hash
    end
  end





  def process_user_generated_error(params)
    converted_json = JSON(params[:deco_error][:json])
    @deco_error.attributes.each_key do |field|
      next if converted_json[field].nil?
      next if excluded_fields.include?(field)

      @deco_error[field] = converted_json[field]
    end
    @deco_error['filter_id'] = 1
    @deco_error['folder_id'] = 1
  end


  def process_api_generated_error(excluded_fields)
    error_fields_and_values = {}
    params['json'].each do |pair|
      next if pair[1].nil? || pair[1] == ''
      next if excluded_fields.include?(pair[0])

      # The gsub removes all ' and " from the string. I do this because
      # can't figure out how to escape and sql INSERT these characters.
      error_fields_and_values[pair[0]] = pair[1].gsub(/'|"/, '')
    end
    error_fields_and_values['filter_id'] = '1'
    error_fields_and_values['folder_id'] = '1'
    error_fields_and_values['created_at'] = Time.now.to_s
    error_fields_and_values['updated_at'] = Time.now.to_s
    keys = error_fields_and_values.keys.join(', ')
    values = error_fields_and_values.values.join("', '")
    sql_string = "INSERT INTO deco_errors (#{keys}) " +
      "VALUES ('#{values}')" +
      'RETURNING id'

    # I can't figure out how to get the status of a PG::result object
    # directly so I do this instead to determine if the error has been saved.
    error_id = DecoError.connection.execute(sql_string)[0]['id']
    sql_insert_success = !!error_id
    resource = { controller: params[:controller], id: error_id }
    RuleEngineWorker.perform_async(resource)
  	return sql_insert_success
  end
































value_as_string = DecoError.forty_two.parameters
value_as_hash = JSON(value_as_string.gsub('=>', ':'))
JSON::ParserError





"{
:set_login_token=>:delete,\n 
:last_shopping_page=>\"/blank_product/96468673/VIP-Golf-Academy-47-MVP\",\n 
\"flash\"=>{},\n 
\"user\"=>nil,\n 
:request_count=>1,\n 
:init_app=>4,\n 
:ref=>nil,\n 
:expiry_time=>Mon Aug 16 23:29:28 +1000 2021,\n 
:validation_key=>\"ndodoslynkawindeprihaxogypolajefrordaquycrybofryho\",\n 
:d_key=>\"mansionridge.deco-apparel.com\",\n 
:return_to_is_public=>true,\n 
:utype=>\"0\",\n 
:brand_id=>12035517,\n 
:back_location=>\n  \"http://mansionridge.deco-apparel.com/blank_product/96468673/VIP-Golf-Academy-47-MVP\",\n 
:return_to=>\n  \"http://mansionridge.deco-apparel.com/blank_product/96468673/VIP-Golf-Academy-47-MVP\",\n 
:init_url=>\"/blank_product/96468673/VIP-Golf-Academy-47-MVP\",\n 
:afid=>111282
}"

':ref=>nil'.gsub(/\:(\w+)\=\>([\w]+)/, '\'\1\': \'\2\'')

data_as_string = DecoError.first.parameters
data_as_string[1..-2] = data_as_string[1..-2].gsub(/[\{]/, ' (open curly brace) ')
data_as_string[1..-2] = data_as_string[1..-2].gsub(/[\}]/, ' (close curly brace) ')
data_as_string.gsub!(/"/,"") # converts " into '
data_as_string.gsub!(/([\:\w\-\/\']+)\=\>([\w\-\/\s\'\:\(\)\+\.]+)/, '"\1": "\2"')
data_as_string.gsub!(/\n/, '')
data_as_hash = JSON(data_as_string)

{:set_login_token=>:delete}.to_json






my_hash = {
	":set_login_token": ":delete",
	":last_shopping_page": "'/blank_product/96468673/VIP-Golf-Academy-47-MVP'",
	"'flash'": " (open curly brace)  (close curly brace) ",
	"'user'": "nil",
	":request_count": "1",
	":init_app": "4",
	":ref": "nil",
	":expiry_time": " Aug 16 23:29:28 +1000 20",
	":validation_key":"'ndodoslynkawindeprihaxoglajefrordaquycrybofryho'",
	":d_key": "'masiidge.deco-apparel.com'",
	":return_to_is_pbl": "true",
	":utype": "'0'",
	":brand_id": "12035517",
	":back_location": "\n  'http://mansionridge.deco-apparel.com/blank_product/96468673/VIP-Golf-Academy-47-MVP'",
	":return_to": "\n  'http://mansionridge.deco-apparel.com/blank_product/96468673/VIP-Golf-Academy-47-MVP'",
	":init_url": "'/blank_product/96468673/VIP-Golf-Academy-47-MVP'",
	":afid": "111282"
}


# This is the formatted string my gsub code produces
"{
	\":set_login_token\": \":delete\",\n 
	\":last_shopping_page\": \"'/blank_product/96468673/VIP-Golf-Academy-47-MVP'\",\n 
	\"'flash'\": \" (open curly brace)  (close curly brace) \",\n 
	\"'user'\": \"nil\",\n 
	\":request_count\": \"1\",\n 
	\":init_app\": \"4\",\n 
	\":ref\": \"nil\",\n 
	\":expiry_time\": \"Mon Aug 16 23:29:28 +1000 2021\",\n 
	\":validation_key\": \"'ndodoslynkawindeprihaxogypolajefrordaquycrybofryho'\",\n 
	\":d_key\": \"'mansionridge.deco-apparel.com'\",\n 
	\":return_to_is_public\": \"true\",\n 
	\":utype\": \"'0'\",\n 
	\":brand_id\": \"12035517\",\n 
	\":back_location\": \"\n  'http://mansionridge.deco-apparel.com/blank_product/96468673/VIP-Golf-Academy-47-MVP'\",\n 
	\":return_to\": \"\n  'http://mansionridge.deco-apparel.com/blank_product/96468673/VIP-Golf-Academy-47-MVP'\",\n 
	\":init_url\": \"'/blank_product/96468673/VIP-Golf-Academy-47-MVP'\",\n 
	\":afid\": \"111282\"
}"

# This is the string .to_json produces.
"{
	\":set_login_token\":\":delete\",
	\":last_shopping_page\":\"'/blank_product/96468673/VIP-Golf-Academy-47-MVP'\",
	\"'flash'\":\" (open curly brace)  (close curly brace) \",
	\"'user'\":\"nil\",
	\":request_count\":\"1\",
	\":init_app\":\"4\",
	\":ref\":\"nil\",
	\":expiry_time\":\" Aug 16 23:29:28 +1000 20\",
	\":validation_key\":\"'ndodoslynkawindeprihaxoglajefrordaquycrybofryho'\",
	\":d_key\":\"'masiidge.deco-apparel.com'\",
	\":return_to_is_pbl\":\"true\",
	\":utype\":\"'0'\",
	\":brand_id\":\"12035517\",
	\":back_location\":\"\\n  'http://mansionridge.deco-apparel.com/blank_product/96468673/VIP-Golf-Academy-47-MVP'\",
	\":return_to\":\"\\n  'http://mansionridge.deco-apparel.com/blank_product/96468673/VIP-Golf-Academy-47-MVP'\",
	\":init_url\":\"'/blank_product/96468673/VIP-Golf-Academy-47-MVP'\",
	\":afid\":\"111282\"
}"













{"title":"Testing user generated Error","release":"stable","session_data":"{:set_login_token=>:delete,\n :last_shopping_page=>\"/blank_product/96468673/VIP-Golf-Academy-47-MVP\",\n \"flash\"=>{},\n \"user\"=>nil,\n :request_count=>1,\n :init_app=>4,\n :ref=>nil,\n :expiry_time=>Mon Aug 16 23:29:28 +1000 2021,\n :validation_key=>\"ndodoslynkawindeprihaxogypolajefrordaquycrybofryho\",\n :d_key=>\"mansionridge.deco-apparel.com\",\n :return_to_is_public=>true,\n :utype=>\"0\",\n :brand_id=>12035517,\n :back_location=>\n  \"http://mansionridge.deco-apparel.com/blank_product/96468673/VIP-Golf-Academy-47-MVP\",\n :return_to=>\n  \"http://mansionridge.deco-apparel.com/blank_product/96468673/VIP-Golf-Academy-47-MVP\",\n :init_url=>\"/blank_product/96468673/VIP-Golf-Academy-47-MVP\",\n :afid=>111282}"}

# hash
{:set_login_token=>:delete, :last_shopping_page=>"/blank_product/96468673/VIP-Golf-Academy-47-MVP", "flash"=>{}}.to_json
# hash.to_json
"{\"set_login_token\":\"delete\",\"last_shopping_page\":\"/blank_product/96468673/VIP-Golf-Academy-47-MVP\",\"flash\":{}}"
# hash.to_s
"{:set_login_token=>:delete, :last_shopping_page=>\"/blank_product/96468673/VIP-Golf-Academy-47-MVP\", \"flash\"=>{}}"
# error data containing hash.to_json
{"title":"Testing user generated Error","release":"stable","session_data":"{\"set_login_token\":\"delete\",\"last_shopping_page\":\"/blank_product/96468673/VIP-Golf-Academy-47-MVP\",\"flash\":{}}"}

# error data containing hash.to_s
{"title":"Testing user generated Error","release":"stable","session_data":"{:set_login_token=>:delete, :last_shopping_page=>\"/blank_product/96468673/VIP-Golf-Academy-47-MVP\", \"flash\"=>{}}"}




    fields_to_convert_to_hash = %w[parameters, session_data]

  # Error data can contain fields that are strings which represent hashes. 
  # However, these strings might not follow JSON convention, for instance they 
  # might be generated from using Ruby’s .to_s method on a hash. This method 
  # tries a few common patterns to convert the string into a json hash. 
  #
  # @param [string] the string to attempt to turn into a hash.
  # @return [string] the json hash representation of the string if conversion 
  #                  occurred otherwise the parameter string is returned.
  def convert_string_to_json(data_as_string)
    begin
      data_as_hash = JSON(data_as_string)
    rescue JSON::ParserError
      data_as_string[1..-2] = data_as_string[1..-2].gsub(/[\{]/, ' (open curly brace) ')
      data_as_string[1..-2] = data_as_string[1..-2].gsub(/[\}]/, ' (close curly brace) ')
      data_as_string.gsub!(/"/,"") # converts " into '
      data_as_string.gsub!(/([\:\w\-\/\']+)\=\>([\w\-\/\s\'\:\(\)\+\.]+)/, '"\1": "\2"')
      data_as_string.gsub!(/\n/, '')
      begin
        data_as_hash = JSON(data_as_string)
      rescue JSON::ParserError
        return data_as_string
      else 
        return data_as_hash.to_json
      end
    else
      return data_as_hash.to_json
    end
  end

    @hashed_data = {
      parameters: convert_string_to_json(@deco_error.parameters),
      session_data: convert_string_to_json(@deco_error.session_data)
    }











































