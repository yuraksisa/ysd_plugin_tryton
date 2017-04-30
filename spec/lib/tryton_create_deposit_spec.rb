require 'spec_helper'
require "ysd_plugin_tryton/model/ysd_md_tryton_transaction"
require "ysd_plugin_tryton/model/ysd_md_tryton_wrapper"

describe YsdPluginTryton::Integration do

  describe ".create_deposit" do

    it "does error" do

       # Build request
       expect(YsdPluginTryton::Integration).to receive(:build_create_deposit_request).and_return({done: true, response: {}})

       # Get tryton configuration
       expect(SystemConfiguration::SecureVariable).to receive(:get_value).and_return(
       	                          'url',
       	                          'db',
       	                          'user',
       	                          'pass')

       # Tryton wrapper
       wrapper = double("YsdMdTrytonWrapper")
       expect(YsdPluginTryton::YsdMdTrytonWrapper).to receive(:new).and_return(wrapper)

       expect(wrapper).to receive(:create_deposit).and_return({done: false, response: 'Error'})

       # Store error
       expect(ExternalIntegration::Error).to receive(:create).with(source_system: 'mybooking',
                                                                   source_entity: 'charge',
                                                                   source_id: 1234,
                                                                   destination_system: 'tryton',
                                                                   destination_entity: 'sale.deposit',
                                                                   message: 'Error')

       YsdPluginTryton::Integration.create_deposit(1234)

    end

    it "creates deposit" do

       # Build request
       expect(YsdPluginTryton::Integration).to receive(:build_create_deposit_request).and_return({done: true, response: {}})

       # Get tryton configuration
       expect(SystemConfiguration::SecureVariable).to receive(:get_value).and_return(
       	                          'url',
       	                          'db',
       	                          'user',
       	                          'pass')

       # Tryton wrapper
       wrapper = double("YsdMdTrytonWrapper")
       expect(YsdPluginTryton::YsdMdTrytonWrapper).to receive(:new).and_return(wrapper)

       expect(wrapper).to receive(:create_deposit).and_return({done: true, response: {"sale.deposit"=>17}})

       # Store integrated data
       expect(ExternalIntegration::Data).to receive(:create).with(source_system: 'mybooking',
             	                                                  source_entity: 'charge',
             	                                                  source_id: 1234,
             	                                                  destination_system: 'tryton',
             	                                                  destination_entity: 'sale.deposit',
             	                                                  destination_id: 17)

       YsdPluginTryton::Integration.create_deposit(1234)

    end

    it "creates sale" do

       # Build request
       expect(YsdPluginTryton::Integration).to receive(:build_create_deposit_request).and_return({done: true, response: {}})

       # Get tryton configuration
       expect(SystemConfiguration::SecureVariable).to receive(:get_value).and_return(
       	                          'url',
       	                          'db',
       	                          'user',
       	                          'pass')

       # Tryton wrapper
       wrapper = double("YsdMdTrytonWrapper")
       expect(YsdPluginTryton::YsdMdTrytonWrapper).to receive(:new).and_return(wrapper)

       expect(wrapper).to receive(:create_deposit).and_return({done: true, response: {"sale.sale"=>17}})

       # Store integrated data
       expect(ExternalIntegration::Data).to receive(:create).with(source_system: 'mybooking',
             	                                                  source_entity: 'charge',
             	                                                  source_id: 1234,
             	                                                  destination_system: 'tryton',
             	                                                  destination_entity: 'sale.sale',
             	                                                  destination_id: 17)

       YsdPluginTryton::Integration.create_deposit(1234)

    end

  end

end