require 'spec_helper'
require 'shared_booking'
require "ysd_plugin_tryton/model/ysd_md_tryton_charge_observer"
require "ysd_plugin_tryton/model/ysd_md_tryton_create_deposit"
require "ysd_plugin_tryton/model/ysd_md_tryton_booking_extension"
require 'date'
require 'bigdecimal'

describe YsdPluginTryton::ChargeObserver do

    describe "after a charge confirmation do notify to Tryton" do

      include_context "shared booking"

      it "notifies to Tryton" do

        # Define two expectations to mock the mail notification when creating a booking
        expect(booking_1_line_no_extras_2_days).to receive(:notify_manager)
        expect(booking_1_line_no_extras_2_days).to receive(:notify_request_to_customer)

        # Creates the booking
        booking_1_line_no_extras_2_days.save
        
        # Creates the charge
        charge = Payments::Charge.create(date: DateTime.strptime('2017-03-26', '%Y-%m-%d'),
        	                            amount: BigDecimal.new('10.00'),
        	                            currency: 'EUR',
        	                            status: :pending)
        # Creates the booking charge
        booking_charge = BookingDataSystem::BookingCharge.create(booking: booking_1_line_no_extras_2_days,
        	                                                     charge: charge)

        # Define an expectation (when the charge status is updated to done, 
        # creates a deposit in Tryton)
        expect(YsdPluginTryton::Integration).to receive(:create_deposit)
           .with(charge.id).and_return({done: true, detail: '1'})

        # Define expectations to mock configuration 
        expect(SystemConfiguration::Variable).to receive(:get_value).with('booking.notify_confirmation','true').and_return('false')
        expect(SystemConfiguration::Variable).to receive(:get_value).with('booking.hours_cadence',2).and_return(2)
        expect(SystemConfiguration::Variable).to receive(:get_value).with('tryton.sync_deposit','false').and_return('true')

        # Do the process
        charge.update(status: :done)   

      end

    end	

end	