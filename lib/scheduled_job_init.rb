require 'rufus/scheduler'

scheduler = Rufus::Scheduler.start_new

scheduler.every('30m', blocking: true, first_in: '1s') do
  require 'job/item_list_refresh'
  Job::ItemListRefresh.run
end
