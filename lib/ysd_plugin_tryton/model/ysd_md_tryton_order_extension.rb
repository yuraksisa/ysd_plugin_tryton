module YsdPluginTryton
	module OrderExtension
		#
		# Get a representation of the booking line for tryton
		#
    def lines_to_tryton
      result = []

      order_items.each do |order_item|

       	if tryton_product = ::ExternalIntegration::Data.first(source_system: 'mybooking',
        	                                                    source_entity: 'product',
       		                                                    source_id: "#{order_item.item_id}-#{order_item.item_price_type}",
                                                              destination_system: 'tryton',
                                                              destination_entity: 'product.template')
          result << {
                      "product" => tryton_product.destination_id.to_i,
                      "description" => "#{order_item.item_description} (#{order_item.item_price_description})",
                      "gross_unit_price_w_tax" => {
                        "__class__" => "Decimal",
                        "decimal" => "%.2f" % order_item.item_unit_cost
                      },
                      "quantity" => order_item.quantity
          	        }
        end

      end	
      return result
    end
	end
	Yito::Model::Order::Order.include(OrderExtension)
end