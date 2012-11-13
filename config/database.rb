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

uri = URI.parse(ENV["REDISTOGO_URL"] || 'redis://localhost:6379')

redis_config = { adapter: 'redis', host: uri.host, port: uri.port, password: uri.password }

case Padrino.env
  when :development then DataMapper.setup(:default, redis_config)
  when :production  then DataMapper.setup(:default, redis_config)
  when :test        then DataMapper.setup(:default, redis_config)
end

STDERR.puts("Env: #{Padrino.env}")