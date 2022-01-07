require "test_helper"

class BulkActionFormTest < ActionDispatch::IntegrationTest
  def setup
    @uncategorised_folder = Folder.create(name: "Uncategorised")
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

    30.times do |num|
      DecoError.create(read: false,
                        title: "Error Number #{num}",
                        filter_id: 1)
    end
  end

  test 'navigate to home page' do
    get root_path
    assert_template 'application/home'
  end 

  test 'navigate to folder show page' do
    get '/folders/1'
    assert_template 'folders/show_main_content', 'folders/show_tool_bar'
  end 

  test 'Update true read status via strong params' do
    assert_equal false, DecoError.find(1).read
    get bulk_action_path, params: { deco_error: {read: "1"},
                                    submission_data: 'routeToDecoErrorUpdate',
                                    id: ['1', '2'],
                                    controller: 'deco_errors',
                                    action: 'update',
                                    folder_id: 1,
                                    read: true}
    assert_equal true, DecoError.find(1).read
  end

  test 'Update false read status via strong params' do
    DecoError.find(1).update(read: true)
    assert_equal true, DecoError.find(1).read
    get bulk_action_path, params: { deco_error: {read: "0"},
                                    submission_data: 'routeToDecoErrorUpdate',
                                    id: ['1', '2'],
                                    controller: 'deco_errors',
                                    action: 'update',
                                    folder_id: 1,
                                    read: false}
    assert_equal false, DecoError.find(1).read
  end

  test 'Does not break when no deco_error params are entered' do
    get bulk_action_path, params: { submission_data: 'routeToDecoErrorUpdate',
                                    id: ['1', '2'],
                                    controller: 'deco_errors',
                                    action: 'update',
                                    folder_id: 1,
                                    read: false}
    assert_response :redirect
  end
end
