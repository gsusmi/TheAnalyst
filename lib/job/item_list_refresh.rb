# TODO: require list fetcher.
require 'ostruct'

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
      @config[:list_url]
    end

    def run
      # Fetch items! Resolve items!
    end
  end
end
