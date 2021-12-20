require "test_helper"

class DecoErrorTest < ActiveSupport::TestCase
  def setup 
    @folder = Folder.create(name: 'Test Folder')
    @filter = Filter.create(name: 'Test Filter',
                          execution_order: 1,
                          logic: '',
                          folder_id: 1)
    @deco_error = DecoError.new(title: "Test Error",
                                read: false,
                                filter_id: 1)
  end

  test 'should be valid' do
    assert @deco_error.valid?
  end

  test 'should be able to change read status' do
    @deco_error.read = true
    assert_equal true, @deco_error.read
    @deco_error.read = false
    assert_equal false, @deco_error.read
  end

  test 'should be able to reassign to different filter' do
    filter_2 = Filter.create(name: 'Test Filter 2',
                          execution_order: 2,
                          logic: '',
                          folder_id: 1)
    @deco_error.filter_id = 2
    assert_equal 2, @deco_error.filter_id
    assert @deco_error.valid?
  end

  test 'should be able to add deco error to a folder' do
    skip
    @deco_error.folders << @folder
    assert_equal @folder, deco_error.folders
  end
end
