require 'test_helper'

class FolderTest < ActiveSupport::TestCase
  def setup
    @folder = Folder.new(name: 'Test Folder')
  end

  test 'should be valid' do
    assert @folder.valid?
  end

  test 'name should be present' do
    @folder.name = ''
    assert_not @folder.valid?
    @folder.name = '           '
    assert_not @folder.valid?
  end

  test 'name should not be too long' do
    @folder.name = 'a' * 51
    assert_not @folder.valid?
  end

  test 'name should be unique' do
    duplicate_folder = @folder.dup
    @folder.save!
    assert_not duplicate_folder.valid?
  end

  test 'should be able to add parent' do
    @folder.save!
    child_folder = Folder.new(name: 'Test Child Folder',
                              parent_id: 1
                             )
    assert child_folder.valid?
  end

  test 'should be able to add deco error to a folder' do
    skip
    deco_error = DecoError.new(title: 'Test error')
    deco_error.folders << @folder
    assert_equal @folder, deco_error.folders
  end
end
