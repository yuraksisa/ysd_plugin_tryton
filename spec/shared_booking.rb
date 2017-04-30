shared_context "shared booking" do 

 #
 # Defines a booking with 1 line, no extras and 2 days
 #
 let(:booking_1_line_no_extras_2_days) do

    BookingDataSystem::Booking.new(
        date_from: DateTime.strptime('2017-05-01','%Y-%m-%d'),
      	date_to: DateTime.strptime('2017-05-02','%Y-%m-%d'),
      	customer_name: 'Name',
      	customer_surname: 'Surname',
      	customer_email: 'info@myemail.com',
      	customer_phone: '555555555',
      	item_cost: BigDecimal.new('40.00'),
      	total_cost: BigDecimal.new('40.00'),
      	total_paid: BigDecimal.new('00.00'),
      	total_pending: BigDecimal.new('40.00'),
        days: 2,
      	booking_lines: [
             BookingDataSystem::BookingLine.new(
                item_id: 'SK',
      	        item_description: 'Kayak',
      	        quantity: 2,
      	        item_unit_cost: BigDecimal.new('20.00'),
      	        item_cost: BigDecimal.new('40.00')
             )
      	]
    )

 end

 #
 # Defines a booking with 1 line, no extras and 10 days
 #
 let(:booking_1_line_no_extras_10_days) do

    BookingDataSystem::Booking.new(
        date_from: DateTime.strptime('2017-05-01','%Y-%m-%d'),
        date_to: DateTime.strptime('2017-05-10','%Y-%m-%d'),
        customer_name: 'Name',
        customer_surname: 'Surname',
        customer_email: 'info@myemail.com',
        customer_phone: '555555555',
        item_cost: BigDecimal.new('300.00'),
        total_cost: BigDecimal.new('300.00'),
        total_paid: BigDecimal.new('00.00'),
        total_pending: BigDecimal.new('300.00'),
        days: 10,
        booking_lines: [
             BookingDataSystem::BookingLine.new(
                item_id: 'SK',
                item_description: 'Kayak',
                quantity: 3,
                item_unit_cost: BigDecimal.new('100.00'),
                item_cost: BigDecimal.new('300.00')
             )
        ]
    )

 end 

 #
 # Defines a booking with 1 line, 1 extra (unitary price) for 9 days
 #
 let(:booking_1_line_1_extra_unitary_9_days) do

    BookingDataSystem::Booking.new(
        date_from: DateTime.strptime('2017-05-01','%Y-%m-%d'),
        date_to: DateTime.strptime('2017-05-09','%Y-%m-%d'),
        customer_name: 'Name',
        customer_surname: 'Surname',
        customer_email: 'info@myemail.com',
        customer_phone: '555555555',
        item_cost: BigDecimal.new('270.00'),
        extras_cost: BigDecimal.new('135.00'),
        total_cost: BigDecimal.new('405.00'),
        total_paid: BigDecimal.new('00.00'),
        total_pending: BigDecimal.new('405.00'),
        days: 9,
        booking_lines: [
             BookingDataSystem::BookingLine.new(
                item_id: 'SK',
                item_description: 'Kayak',
                quantity: 3,
                item_unit_cost: BigDecimal.new('90.00'),
                item_cost: BigDecimal.new('270.00')
             )
        ],
        booking_extras: [
             BookingDataSystem::BookingExtra.new(
                extra_id: 'toldo',
                extra_description: 'Toldo',
                quantity: 1,
                extra_unit_cost: BigDecimal.new('135.00'),
                extra_cost: BigDecimal.new('135.00'))
        ]
    )

 end 

 #
 # Defines a booking with 1 line, 1 extra (detailed prices) for 11 days
 #
 let(:booking_1_line_1_extra_detailed_11_days) do

    BookingDataSystem::Booking.new(
        date_from: DateTime.strptime('2017-05-01','%Y-%m-%d'),
        date_to: DateTime.strptime('2017-05-09','%Y-%m-%d'),
        customer_name: 'Name',
        customer_surname: 'Surname',
        customer_email: 'info@myemail.com',
        customer_phone: '555555555',
        item_cost: BigDecimal.new('330.00'),
        extras_cost: BigDecimal.new('110.00'),
        total_cost: BigDecimal.new('440.00'),
        total_paid: BigDecimal.new('00.00'),
        total_pending: BigDecimal.new('440.00'),
        days: 11,
        booking_lines: [
             BookingDataSystem::BookingLine.new(
                item_id: 'SK',
                item_description: 'Kayak',
                quantity: 3,
                item_unit_cost: BigDecimal.new('110.00'),
                item_cost: BigDecimal.new('330.00')
             )
        ],
        booking_extras: [
             BookingDataSystem::BookingExtra.new(
                extra_id: 'cubre_pro',
                extra_description: 'Cubre PRO',
                quantity: 1,
                extra_unit_cost: BigDecimal.new('110.00'),
                extra_cost: BigDecimal.new('110.00'))
        ]
    )

 end 

 #
 # Defines price definitions
 #
 let(:price_definition_unitary) do

  Yito::Model::Rates::PriceDefinition.new(
                units_management: :unitary,
                units_management_value: 1,
                prices: [
                  Yito::Model::Rates::Price.new(price: 15, units: 1)
                  ])

 end

 let(:price_definition_detailed_7_days) do

  Yito::Model::Rates::PriceDefinition.new(
                units_management: :detailed,
                units_management_value: 7,
                prices: [
                  Yito::Model::Rates::Price.new(price: 10, units: 1),
                  Yito::Model::Rates::Price.new(price: 20, units: 2),
                  Yito::Model::Rates::Price.new(price: 30, units: 3),
                  Yito::Model::Rates::Price.new(price: 40, units: 4),
                  Yito::Model::Rates::Price.new(price: 50, units: 5),
                  Yito::Model::Rates::Price.new(price: 60, units: 6),
                  Yito::Model::Rates::Price.new(price: 70, units: 7),
                  Yito::Model::Rates::Price.new(price: 10, units: 0)
                  ])

 end





end