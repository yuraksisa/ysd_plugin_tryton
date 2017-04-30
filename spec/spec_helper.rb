require 'ysd_md_booking'
require 'ysd_md_order'
require 'ysd_md_integration'
require 'ysd_plugin_tryton'

module DataMapper
  class Transaction
  	module SqliteAdapter
      def supports_savepoints?
        true
      end
  	end
  end
end

Delayed::Worker.backend = :data_mapper
Delayed::Worker.delay_jobs = false # To avoid delay (and do the task inmediatly)

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup :default, "sqlite3::memory:"
DataMapper::Model.raise_on_save_failure = false
DataMapper.finalize 

DataMapper.auto_migrate!

