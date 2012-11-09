require 'analyst-lib'

module Task
  class BeerMetadataSync
    def self.sync_metadata(beer)
      STDERR.puts("sync_metadata: #{beer}")
      meta = AnalystLib.beer_metadata(beer.name)
      beer.attributes = {
        rating_score: meta.rating_score.to_i,
        item_type: meta.item_type,
        abv: meta.abv.to_f
      }
      beer.save
    rescue AnalystLib::MetadataNotFound
      STDERR.puts("No metadata known for #{beer}")
    end
  end
end
