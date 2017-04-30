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
    #  - Integrates to Tryton
    #
    after :update do |charge|

      if SystemConfiguration::Variable.get_value('tryton.sync_deposit','false').to_bool

        if charge.status == :done
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

    after :create do |charge|

      if SystemConfiguration::Variable.get_value('tryton.sync_deposit','false').to_bool
      
        if charge.status == :done
          Integration.delay.create_deposit(charge.id)
        end

      end  

    end
    
  end
end