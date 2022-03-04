require 'json'
require 'pp'
require 'pry'
require "awesome_print"
params = "{\"username\"=>\"SigCon_Deco_Prod\", \"sortby\"=>\"5\", \"controller\"=>\"api/json/manage_inventory\", \"password\"=>\"z8gWv_pd9*HLpz$c\", \"action\"=>\"find\", \"conditions\"=>{\"1\"=>{\"field\"=>\"5\", \"condition\"=>\"6\", \"date1\"=>\"2021-06-10T00:53:58\"}}}"
params_as_hash = {"username"=>"SigCon_Deco_Prod", "sortby"=>"5", "controller"=>"api/json/manage_inventory", "password"=>"z8gWv_pd9*HLpz$c", "action"=>"find", "conditions"=>{"1"=>{"field"=>"5", "condition"=>"6", "date1"=>"2021-06-10T00:53:58"}}}


pp JSON(params.gsub('=>', ':'))

puts '-----------------------------------------'
puts JSON.pretty_generate(JSON(params.gsub('=>', ':')))

puts '-----------------------------------------'
Pry::ColorPrinter.pp(JSON(params.gsub('=>', ':')))

puts '-----------------------------------------'
ap JSON(params.gsub('=>', ':')), options = {}


session_data = "{:set_login_token=>:delete,\n \"user\"=>nil,\n :last_shopping_page=>\n  \"/create_products/Women-s-Oasis-Wash-French-Terry-Hooded-Full-Zip-Sweatshirt?dp=2&n=38694857&pn=1&pn_p=98\",\n :request_count=>1,\n :init_app=>4,\n :ref=>nil,\n :expiry_time=>Mon Aug 16 22:02:19 +1000 2021,\n :validation_key=>\"vecovakofrustaphorastosyprodondususpecrifrymetryly\",\n :d_key=>\"bei.deco-catalog.com\",\n :return_to_is_public=>true,\n :utype=>\"0\",\n \"flash\"=>{},\n :brand_id=>11257953,\n :back_location=>\n  \"http://bei.deco-catalog.com/create_products/Women-s-Oasis-Wash-French-Terry-Hooded-Full-Zip-Sweatshirt?dp=2&n=38694857&pn=1&pn_p=98\",\n :return_to=>\n  \"http://bei.deco-catalog.com/create_products/Women-s-Oasis-Wash-French-Terry-Hooded-Full-Zip-Sweatshirt?dp=2&n=38694857&pn=1&pn_p=98\",\n :init_url=>\n  \"/create_products/Women-s-Oasis-Wash-French-Terry-Hooded-Full-Zip-Sweatshirt?dp=2&n=38694857&pn=1&pn_p=98\",\n :afid=>84543}"
session_data.gsub!(/:(\w)=>/, /\1/)
p session_data
