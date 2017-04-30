module YsdPluginTryton
  module Integration
    
    #
    # Create a deposit in Tryton
    #
    # return [Hash] 
    #
    #   The key result: has two values 'ok' or 'error' 
    #   The key detail: shows information about the process (error message ...)
    #   
    #
    def self.create_deposit(charge_id)

       request = build_create_deposit_request(charge_id) 
       
       if request[:done]
         # Creates the wrapper to connect to Tryton
         url = SystemConfiguration::SecureVariable.get_value('tryton.url')
         database = SystemConfiguration::SecureVariable.get_value('tryton.database')
         username = SystemConfiguration::SecureVariable.get_value('tryton.username')
         password = SystemConfiguration::SecureVariable.get_value('tryton.password')
         wrapper = YsdMdTrytonWrapper.new(url, database, username, password)

         # Create the deposit
         result = wrapper.create_deposit(request[:response])
         if result[:done] # Deposit created
           if result[:response].nil?
             error_message = 'Tryton response is empty'
           else
             if result[:response].has_key?('sale.deposit')
               data = ExternalIntegration::Data.create(source_system: 'mybooking',
             	                                     source_entity: 'charge',
             	                                     source_id: charge_id,
             	                                     destination_system: 'tryton',
             	                                     destination_entity: 'sale.deposit',
             	                                     destination_id: result[:response]['sale.deposit'])
             elsif result[:response].has_key?('sale.sale')
               data = ExternalIntegration::Data.create(source_system: 'mybooking',
                                                   source_entity: 'charge',
                                                   source_id: charge_id,
                                                   destination_system: 'tryton',
                                                   destination_entity: 'sale.sale',
                                                   destination_id: result[:response]['sale.sale'])
             end 
             return {done: true, response: data}
           end
         else
           error_message = result[:response] # Error creating deposit          
         end	
       else 
       	 error_message = request[:response] # Error building deposit
       end   
       
       error = ExternalIntegration::Error.create(source_system: 'mybooking',
                                                 source_entity: 'charge',
                                                 source_id: charge_id,
                                                 destination_system: 'tryton',
                                                 destination_entity: 'sale.deposit',
                                                 message: error_message)	
       return {done: false, response: error_message}  

    end

    #
    # Build the Tryton request to create a deposit
    #
    # The charge status must be :done
    #
    # return [Hash] The full request to create a deposit in tryton
    #
    #
    def self.build_create_deposit_request(charge_id)

       if ExternalIntegration::Data.first(source_system: 'mybooking',
       	                                  source_entity: 'charge',
       	                                  source_id: charge_id.to_s,
       	                                  destination_system: 'tryton',
       	                                  destination_entity: 'sales.deposit')
         return {done: false, response: 'The charge has already been processed'}
       else
         if charge = Payments::Charge.get(charge_id)
           if charge.status == :done
             if charge_source = charge.charge_source          
               source = if charge_source.is_a?BookingDataSystem::BookingCharge 
                          charge_source.booking
                        elsif charge_source.is_a?Yito::Model::Order::OrderCharge
                          charge_source.order 
                        else
                          raise "Source is not valid"
                        end  

               # Build the request
               request = {
       	                   "method" => "model.sale.deposit.manage",
       	                   "params" => []
                         }

               # Parameter 1 : Lines
               request["params"] << {
                                      "currency" => 24,
                                      "party" => 4,
                                      "lines" => source.lines_to_tryton
                                    }

               # Parameter 2 : Reference and amount
               request["params"] << {
                                      "reference" => source.id.to_s,
                                      "amount"    => {
                                	      "__class__" => "Decimal",
                                	      "decimal" => "%.2f" % charge_source.charge.amount
                                      }
                                    }
               # Parameter 3 : journal                     
               request["params"] << {
           	                       "journal" => 3
                                  }   
               return {done: true, response: request}
             else
           	   return {done: false, response: 'There is not charge_source tied to the charge'}
             end 
           else
             return {done: false, response: "Charge status not valid. It must be done. Current status is #{charge.status}"}
           end
         else
           return {done: false, response: "Charge #{charge_id} does not exist"}
         end
       end           

    end

  end
end