class Item
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :metadata_known, Boolean
  property :description, String
  property :item_type, String
end
