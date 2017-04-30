module YsdPluginTryton
	module BookingExtension
		#
		# Get a representation of the booking line for tryton
		#
    def lines_to_tryton
      result = []
      
      # Build lines
      result.concat(items_to_tryton) if booking_lines.size > 0

      # Build extras
      result.concat(extras_to_tryton) if booking_extras.size > 0

      return result
    end

    protected 

    # ---------------------- Booking lines -----------------------

    #
    # Prepare booking_lines to tryton
    #
    def items_to_tryton

      result = []

      booking_lines.each do |booking_line|

          product = ::Yito::Model::Booking::BookingCategory.get(booking_line.item_id)
          product_price_definition = product.price_definition

          if product_price_definition.units_management == :unitary
            if tryton_product = ::ExternalIntegration::Data.first(source_system: 'mybooking',
                                                                  source_entity: 'product',
                                                                  source_id: booking_line.item_id,
                                                                  destination_system: 'tryton',
                                                                  destination_entity: 'product.template')
              result << {
                          "product" => tryton_product.destination_id.to_i,
                          "description" => booking_line.item_description,
                          "gross_unit_price_w_tax" => {
                            "__class__" => "Decimal",
                            "decimal" => "%.2f" % booking_line.item_unit_cost
                          },
                          "quantity" => booking_line.quantity
                        }
            else
              # Tryton product not found
            end            
          elsif product_price_definition.units_management == :detailed
            if self.days < product_price_definition.units_management_value #do not apply extra days
              if tryton_product = ::ExternalIntegration::Data.first(source_system: 'mybooking',
                                                                    source_entity: 'product',
                                                                    source_id: "#{booking_line.item_id}-#{self.days}",
                                                                    destination_system: 'tryton',
                                                                    destination_entity: 'product.template')          
                result << {
                            "product" => tryton_product.destination_id.to_i,
                            "description" => build_product_with_days_description(booking_line.item_description, self.days),
                            "gross_unit_price_w_tax" => {
                              "__class__" => "Decimal",
                              "decimal" => "%.2f" % booking_line.item_unit_cost
                            },
                            "quantity" => booking_line.quantity
                          } 
              else
                # Tryton product not found
              end                                                                              
            else # apply extra days
              max_days = product_price_definition.units_management_value
              max_days_price = product_price_definition.prices.select {|item| max_days == item.units}.first.price

              if tryton_product = ::ExternalIntegration::Data.first(source_system: 'mybooking',
                                                                    source_entity: 'product',
                                                                    source_id: "#{booking_line.item_id}-#{max_days}",
                                                                    destination_system: 'tryton',
                                                                    destination_entity: 'product.template')          
                result << {
                            "product" => tryton_product.destination_id.to_i,
                            "description" => build_product_with_days_description(booking_line.item_description, max_days),
                            "gross_unit_price_w_tax" => {
                              "__class__" => "Decimal",
                              "decimal" => "%.2f" % max_days_price
                            },
                            "quantity" => booking_line.quantity
                          }               
              else
                # Tryton product not found 
              end            
              extra_days = self.days - max_days
              extra_day_price = product_price_definition.prices.select {|item| 0 == item.units}.first.price
              if tryton_product = ::ExternalIntegration::Data.first(source_system: 'mybooking',
                                                                    source_entity: 'product',
                                                                    source_id: "#{booking_line.item_id}-EXTRA",
                                                                    destination_system: 'tryton',
                                                                    destination_entity: 'product.template')
                 result << {
                            "product" => tryton_product.destination_id.to_i,
                            "description" => build_product_with_extra_days_description(booking_line.item_description),
                            "gross_unit_price_w_tax" => {
                              "__class__" => "Decimal",
                              "decimal" => "%.2f" % extra_day_price
                            },
                            "quantity" => booking_line.quantity * extra_days
                          }               

              else
                # Tryton product not found
              end
            end 
          end          

      end

      return result

    end

    def build_product_with_days_description(description, days)
      "#{description} #{YsdPluginTryton.r18n.t.tryton.days(days)}"
    end

    def build_product_with_extra_days_description(description)
      YsdPluginTryton.r18n.t.tryton.extra_days(description)
    end

    # ---------------------- Booking extras -----------------------

    #
    # Prepare booking extras to Tryton
    #
    def extras_to_tryton

      result = []

      booking_extras.each do |booking_extra|

          extra = ::Yito::Model::Booking::BookingExtra.get(booking_extra.extra_id)
          extra_price_definition = extra.price_definition

          if extra_price_definition.units_management == :unitary
            if tryton_product = ::ExternalIntegration::Data.first(source_system: 'mybooking',
                                                                  source_entity: 'product',
                                                                  source_id: booking_extra.extra_id,
                                                                  destination_system: 'tryton',
                                                                  destination_entity: 'product.template')
              result << {
                          "product" => tryton_product.destination_id.to_i,
                          "description" => booking_extra.extra_description,
                          "gross_unit_price_w_tax" => {
                            "__class__" => "Decimal",
                            "decimal" => "%.2f" % booking_extra.extra_unit_cost
                          },
                          "quantity" => booking_extra.quantity
                        }
            else
              # Tryton product not found
            end            
          elsif extra_price_definition.units_management == :detailed
            if self.days < extra_price_definition.units_management_value #do not apply extra days
              if tryton_product = ::ExternalIntegration::Data.first(source_system: 'mybooking',
                                                                    source_entity: 'product',
                                                                    source_id: "#{booking_extra.extra_id}-#{self.days}",
                                                                    destination_system: 'tryton',
                                                                    destination_entity: 'product.template')          
                result << {
                            "product" => tryton_product.destination_id.to_i,
                            "description" => build_extra_with_days_description(booking_extra.extra_description, self.days),
                            "gross_unit_price_w_tax" => {
                              "__class__" => "Decimal",
                              "decimal" => "%.2f" % booking_extra.extra_unit_cost
                            },
                            "quantity" => booking_line.quantity
                          } 
              else
                # Tryton product not found
              end                                                                              
            else # apply extra days
              max_days   = extra_price_definition.units_management_value
              max_days_price = extra_price_definition.prices.select {|item| max_days == item.units}.first.price
              if tryton_product = ::ExternalIntegration::Data.first(source_system: 'mybooking',
                                                                    source_entity: 'product',
                                                                    source_id: "#{booking_extra.extra_id}-#{max_days}",
                                                                    destination_system: 'tryton',
                                                                    destination_entity: 'product.template')          
                result << {
                            "product" => tryton_product.destination_id.to_i,
                            "description" => build_extra_with_days_description(booking_extra.extra_description, max_days),
                            "gross_unit_price_w_tax" => {
                              "__class__" => "Decimal",
                              "decimal" => "%.2f" % max_days_price
                            },
                            "quantity" => booking_extra.quantity
                          }               
              else
                # Tryton product not found 
              end            
              extra_days = self.days - max_days
              extra_day_price = extra_price_definition.prices.select {|item| 0 == item.units}.first.price
              if tryton_product = ::ExternalIntegration::Data.first(source_system: 'mybooking',
                                                                    source_entity: 'product',
                                                                    source_id: "#{booking_extra.extra_id}-EXTRA",
                                                                    destination_system: 'tryton',
                                                                    destination_entity: 'product.template')
                 result << {
                            "product" => tryton_product.destination_id.to_i,
                            "description" => build_extra_with_extra_days_description(booking_extra.extra_description),
                            "gross_unit_price_w_tax" => {
                              "__class__" => "Decimal",
                              "decimal" => "%.2f" % extra_day_price
                            },
                            "quantity" => booking_extra.quantity * extra_days
                          }               

              else
                # Tryton product not found
              end
            end 
          end          

      end

      return result

    end

    def build_extra_with_days_description(description, days)
      "#{description} #{YsdPluginTryton.r18n.t.tryton.days(days)}"
    end

    def build_extra_with_extra_days_description(description)
      YsdPluginTryton.r18n.t.tryton.extra_days(description)
    end    

	end
	BookingDataSystem::Booking.include(BookingExtension)
end