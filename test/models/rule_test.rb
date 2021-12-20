require "test_helper"

class RuleTest < ActiveSupport::TestCase
  def setup
    @folder = Folder.create(name: 'Test Folder')
    @filter = Filter.create(name: 'Test Filter',
                            execution_order: 1,
                            logic: '',
                            folder_id: 1)
    @rule = Rule.new(field: 'title',
                      value: 'Bad file descript',
                      filter_id: 1)
  end

  test 'should be valid' do
    assert @rule.valid?
  end

  test 'the field should match a deco error field' do
    assert_includes DecoError.new.attributes.keys, @rule.field
  end

  test 'value should be present' do
    @rule.value = ""
    assert_not @rule.valid?
    @rule.value = "           "
    assert_not @rule.valid?
  end

  test 'the filter_id should never be nil' do
    @rule.filter_id = nil
    assert_not @rule.valid?
  end
end
