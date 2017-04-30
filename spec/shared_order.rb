shared_context "shared order" do 

 #
 # Defines an order with 1 line
 #
 let(:order_2_lines_different_price_type) do

    Yito::Model::Order::Order.new(
      	customer_name: 'Name',
      	customer_surname: 'Surname',
      	customer_email: 'info@myemail.com',
      	customer_phone: '555555555',
      	total_cost: BigDecimal.new('85.00'),
      	total_paid: BigDecimal.new('00.00'),
      	total_pending: BigDecimal.new('85.00'),
      	order_items: [
             Yito::Model::Order::OrderItem.new(
                date: DateTime.strptime('2017-05-01','%Y-%m-%d'),
                time: '10:00',
                date_to: DateTime.strptime('2017-05-01','%Y-%m-%d'),
                time_to: '14:00',
                item_id: 'COVES',
      	        item_description: 'Excusión Cales Coves',
                item_price_type: 1,
                item_price_description: 'Adulto',
      	        quantity: 1,
      	        item_unit_cost: BigDecimal.new('50.00'),
      	        item_cost: BigDecimal.new('50.00')
             ),
             Yito::Model::Order::OrderItem.new(
                date: DateTime.strptime('2017-05-01','%Y-%m-%d'),
                time: '10:00',
                date_to: DateTime.strptime('2017-05-01','%Y-%m-%d'),
                time_to: '14:00',
                item_id: 'COVES',
                item_description: 'Excusión Cales Coves',
                item_price_type: 2,
                item_price_description: 'Niño 12 a 14 años',
                quantity: 1,
                item_unit_cost: BigDecimal.new('35.00'),
                item_cost: BigDecimal.new('35.00')
             ),             
      	]
    )

 end

end