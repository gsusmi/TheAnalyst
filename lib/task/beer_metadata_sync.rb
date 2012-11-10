require 'analyst-lib'

module Task
  class BeerMetadataSync
    def self.sync_metadata(beer)
      STDERR.puts("sync_metadata: #{beer}")
      meta = AnalystLib.beer_metadata(beer.name)
      beer.attributes = {
        rating_score: meta.rating_score.to_i,
        item_type: meta.type,
        abv: meta.abv && BigDecimal.new(meta.abv, 2),
        metadata_known: true
      }
      beer.save
    rescue DataMapper::SaveFailureError
      STDERR.puts("Could not save #{beer}: #{beer.errors.map(&:to_s)}")
    rescue AnalystLib::MetadataNotFound
      STDERR.puts("No metadata known for #{beer}")
    end
  end
end
