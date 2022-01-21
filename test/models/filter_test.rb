require 'test_helper'

class FilterTest < ActiveSupport::TestCase
  def setup
    @folder = Folder.create!(name: 'Test Folder')
    @filter = Filter.new(name: 'Test Filter',
                         execution_order: 1,
                         logic: '',
                         folder_id: 1
                        )
  end

  test 'should be valid' do
    assert @filter.valid?
  end

  test 'name should be present' do
    @filter.name = ''
    assert_not @filter.valid?
    @filter.name = '           '
    assert_not @filter.valid?
  end

  test 'name should not be too long' do
    @filter.name = 'a' * 51
    assert_not @filter.valid?
  end

  test 'name should be unique' do
    duplicate_filter = @filter.dup
    @filter.save!
    assert_not duplicate_filter.valid?
  end

  test 'should be able to add deco error to a folder' do
    skip
    rule = Rule.new(field: 'title',
                    value: 'Bad file descript',
                    filter_id: 1
                   )
    assert_equal @filter, rule.filter
  end
  #   test 'execution order should be unique' do
  #     filter_2 = Filter.create!(name: 'Test Filter 2',
  #                               execution_order: 1,
  #                               logic: '',
  #                               folder_id: 1
  #                              )
  #     assert_not @filter.valid?
  #   end
end
