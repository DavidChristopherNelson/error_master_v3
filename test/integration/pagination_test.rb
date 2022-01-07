require "test_helper"

class PaginationTest < ActionDispatch::IntegrationTest
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

  test 'navigate to a folder view' do
    get root_path
    assert_template 'application/home'
    get "/folders/1"
    assert_template 'folders/show_main_content', 'folders/show_tool_bar'
    assert_response :success
  end

  test 'page 0 shows when the folder is first opened' do
    get "/folders/1"
    assert_equal 0, @page_num.to_i
    assert_response :success
  end

  test 'page 1 shows' do
    skip
    get "/folders/1?move_to_page=1"
    assert_equal 1, @page_num.to_i
  end

  test 'left chevron is not displayed on page 0' do
    skip
  end

  test 'right chevron is not displayed on final page' do
    skip
  end
end
