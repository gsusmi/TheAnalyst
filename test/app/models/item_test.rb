require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class ItemTest < Test::Unit::TestCase
  context "Item Model" do
    should 'construct new instance' do
      @item = Item.new
      assert_not_nil @item
    end
  end
end
