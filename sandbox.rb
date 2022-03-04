
require 'json'

my_object = { :array => [1, 2, 3, { :sample => "hash"} ], :foo => "bar" }
#puts JSON.pretty_generate(my_object)

error_data = "{\"n\"=>\"88223082\", \"name\"=>\"Perfect-T-Cotton-T-Shirt\", \"from_name\"=>true, \"action\"=>\"create_product\", \"controller\"=>\"home\"}"
#error_data_hash = JSON(error_data)
#puts JSON.pretty_generate(error_data_hash)

error_hash = {
  "n" => "88223082",
  "name"=>"Perfect-T-Cotton-T-Shirt", 
  "from_name"=>true, 
  "action"=>"create_product", 
  "controller"=>"home"
}


error_string = "{\"n\":\"88223082\",\"name\":\"Perfect-T-Cotton-T-Shirt\",\"from_name\":true,\"action\":\"create_product\",\"controller\":\"home\"}"
puts JSON.pretty_generate(JSON(error_string))


puts JSON.pretty_generate(JSON(error_data.gsub("=>", ":")))

flash.now[:notice] = "We
flash[:message] = "Missing Fields"

{ "action": "design", "ctype": "1", "name": "Lacrosse_Player1", "ct": "0", "from_name": true, "controller": "designs", "c": "22941037", "d": "457869802", "f": "3" }



@article = Article.new(title: "...", body: "...")

    if @article.save


    <%= link_to folder_path(id: @folder.id, rule_engine: true), remote: true do %>
      <%= image_tag("rule-engine.svg", class: "icon white") %>
    <% end %>


    elsif params['ignore']
      field = params['ignore_rule']['field']
      value = params['ignore_rule']['value']
