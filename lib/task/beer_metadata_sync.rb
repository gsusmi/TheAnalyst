require 'analyst-lib'

module Task
  class BeerMetadataSync
    def self.sync_metadata(beer)
      STDERR.puts("sync_metadata: #{beer}")
      meta = AnalystLib.beer_metadata(beer.name)
      beer.attributes = {
        rating_score: self.numeric_rating(meta.rating_score),
        external_link: meta.external_link,
        item_type: meta.type,
        abv: meta.abv && BigDecimal.new(sprintf("%.2f", meta.abv), 2),
        metadata_known: true
      }
      beer.save
    rescue DataMapper::SaveFailureError
      STDERR.puts("Could not save #{beer}: #{beer.errors.map(&:to_s)}")
    rescue AnalystLib::MetadataNotFound
      STDERR.puts("No metadata known for #{beer}")
    end

    def self.numeric_rating(rating)
      return nil if !rating || rating.trim.empty?
      return -1 unless rating =~ /^\d+$/
      rating.to_i
    end
  end
end
