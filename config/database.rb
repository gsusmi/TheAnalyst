##
# A MySQL connection:
# DataMapper.setup(:default, 'mysql://user:password@localhost/the_database_name')
#
# # A Postgres connection:
# DataMapper.setup(:default, 'postgres://user:password@localhost/the_database_name')
#
# # A Sqlite3 connection
# DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "development.db"))
#

DataMapper.logger = logger
DataMapper::Property::String.length(255)
DataMapper::Model.raise_on_save_failure = true

STDERR.puts("ENV: #{ENV.inspect}")

redis_config = { adapter: 'redis', database: ENV["REDISTOGO_URL"] || 'redis://localhost:6379' }

case Padrino.env
  when :development then DataMapper.setup(:default, redis_config)
  when :production  then DataMapper.setup(:default, redis_config)
  when :test        then DataMapper.setup(:default, redis_config)
end
