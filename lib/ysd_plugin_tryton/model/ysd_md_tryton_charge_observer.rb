require 'dm-observer' unless defined?DataMapper::Observer
require 'ysd_md_charge' unless defined?Payments::Charge

module YsdPluginTryton
  #
  # Observes changes on the charge tied to notify tryton
  #
  # - If the charge status is set to done, the charge is transferred to 
  #   tryton
  #	
  class ChargeObserver
    include DataMapper::Observer

    observe Payments::Charge
    
    #
    # After updating a charge
    #
    #  - Integrates to Tryton (do not process if the charge origin is tryton)
    #
    #  IMPORTANT: In order to make this works the process of creating a charge for an order/booking must be the
    #  following:
    #
    #     - Create the charge with 'pending' status
    #     - Create the association between the order/booking and the charge
    #     - Update the charge to 'done' status
    #
    after :update do |charge|

      if SystemConfiguration::SecureVariable.get_value('tryton.sync_deposit','false').to_bool

        sync_only_first_charge = SystemConfiguration::SecureVariable.get_value('tryton.sync_only_first_charge', 'true').to_bool
        
        if ((sync_only_first_charge and charge.charge_order == 1) or (!sync_only_first_charge)) and
           charge.origin != 'tryton' and charge.status == :done
          unless ExternalIntegration::Data.first(source_system: 'mybooking',
                                                 source_entity: 'charge',
                                                 source_id: charge.id.to_s,
                                                 destination_system: 'tryton',
                                                 destination_entity: 'sale.deposit')
            YsdPluginTryton::Integration.delay.create_deposit(charge.id) # Notify the charge to Tryton
          end       
        end

      end  
      
    end
    
  end
end