require "ysd_plugin_tryton/version"

#require "ysd_md_booking" unless defined?BookingDataSystem
#require "ysd_md_payment" unless defined?Payments
#require "ysd_md_integration" unless defined?ExternalIntegration

require "ysd_plugin_tryton/model/ysd_md_tryton_booking_extension"
require "ysd_plugin_tryton/model/ysd_md_tryton_order_extension"
require "ysd_plugin_tryton/model/ysd_md_tryton_charge_extension"
require "ysd_plugin_tryton/model/ysd_md_tryton_transaction"
require "ysd_plugin_tryton/model/ysd_md_tryton_wrapper"
require "ysd_plugin_tryton/model/ysd_md_tryton_create_deposit"
require "ysd_plugin_tryton/model/ysd_md_tryton_charge_observer"

require "ysd_plugin_tryton/yito_integration/ysd_tryton_extension"

require "ysd_plugin_tryton/sinatra/ysd_sinatra_tryton"

require "ysd_plugin_tryton/ysd_plugin_tryton_init"

require 'ysd_md_translation' unless defined?Yito::Translation

module YsdPluginTryton
  extend Yito::Translation::ModelR18

  def self.r18n
    check_r18n!(:tryton_r18n, File.expand_path(File.join(File.dirname(__FILE__), '..', 'i18n')))
  end

end
