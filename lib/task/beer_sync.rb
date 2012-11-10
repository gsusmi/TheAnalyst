require 'task/beer_metadata_sync'

module Task
  class BeerSync
    def self.sync_named_beers(beer_name_list)
      current_beer_names = Set.new(beer_name_list.map { |n| n.strip })

      Item.all.each do |beer|
        if !current_beer_names.include?(beer.name)
          STDERR.puts("Deleting obsolete beer: #{beer}")
          beer.destroy
        end
      end

      beers_needing_sync = []
      beer_name_list.each do |name|
        beer = self.beer_named(name)
        beers_needing_sync << beer unless beer.metadata_known
      end

      beers_needing_sync.each { |beer|
        BeerMetadataSync.sync_metadata(beer)
      }
    end

    def self.beer_named(beer)
      beer = beer.strip
      Item.first_or_create(name: beer)
    end
  end
end
