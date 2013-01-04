# TODO: require list fetcher.
require 'ostruct'
require 'analyst-lib'
require 'task/beer_sync'

module Job
  class ItemListRefresh
    def self.configuration
      @configuration ||= self.read_configuration
    end

    def self.configuration_file
      Padrino.root('config/sources.yml')
    end

    def self.read_configuration
      OpenStruct.new(YAML.load_file(self.configuration_file)['list-source'])
    end

    def self.run
      self.new(self.configuration).run
    end

    def initialize(config)
      @config = config
    end

    def list_url
      @config.url
    end

    def run
      # Fetch items! Resolve items!
      STDERR.puts("SCRAPE: #{self.list_url}")
      all_beers = AnalystLib.beer_list(self.list_url)
      draft_beers = all_beers[:drafts]
      Task::BeerSync.sync_named_beers(draft_beers)
    end
  end
end
