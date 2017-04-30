# http://rspec.info/blog/2014/05/notable-changes-in-rspec-3/
# https://github.com/rspec/rspec-its
require 'spec_helper'
require 'shared_booking'
require 'ysd_md_translation'
require "ysd_plugin_tryton/model/ysd_md_tryton_booking_extension"
require 'date'
require 'bigdecimal'

describe YsdPluginTryton::BookingExtension do

  describe ".lines_to_tryton" do

    include_context "shared booking"

    #
    # Booking with 1 line and no extras for 2 days
    #
    it "booking with 1 line and no extras for 2 days to tryton" do
      
        expected = [{
          "product" => 2,
          "description" => 'Kayak (2 días)',
          "gross_unit_price_w_tax" => {
            "__class__" => "Decimal",
            "decimal" => "20.00"
          },
          "quantity" => 2
        }]

        # Mock to query ExternalIntegration::Data to return the expected code
        # for the product 'SK-2'
        expect(ExternalIntegration::Data).to receive(:first)
            .with(source_system: 'mybooking', 
            	  source_entity: 'product', 
            	  source_id: 'SK-2',
            	  destination_system: 'tryton',
                  destination_entity: 'product.template')
            .and_return(
        	ExternalIntegration::Data.new(
        	    destination_system:'tryton',
        	    destination_entity:'product.template',
        	    destination_id:'2'))

        # Mock to query ::Yito::Model::Booking::BookingCategory do return the expect product 'SK'
        expect(::Yito::Model::Booking::BookingCategory).to receive(:get)
            .with('SK')
            .and_return(::Yito::Model::Booking::BookingCategory.new(
              code: 'SK',
              name: 'Kayak',
              price_definition: price_definition_detailed_7_days))    

        # Do the process
        tryton_lines = booking_1_line_no_extras_2_days.lines_to_tryton

        # Check expectation
        expect(tryton_lines).to eql(expected)

    end

    #
    # Booking with 1 line and no extras for 10 days
    #
    it "booking with 1 line and no extras for 10 days to tryton" do
      
        expected = [{
            "product" => 7,
            "description" => 'Kayak (7 días)',
            "gross_unit_price_w_tax" => {
              "__class__" => "Decimal",
              "decimal" => "70.00"
            },
            "quantity" => 3
          },
          {
            "product" => 8,
            "description" => 'Kayak (día extra)',
            "gross_unit_price_w_tax" => {
              "__class__" => "Decimal",
              "decimal" => "10.00"
            },
            "quantity" => 9
          }                       
        ]

        # Mock to query ExternalIntegration::Data to return the expected code
        # for the products 'SK-7' and 'SK-EXTRA'
        expect(ExternalIntegration::Data).to receive(:first)
            .with(source_system: 'mybooking', 
                source_entity: 'product', 
                source_id: 'SK-7',
                destination_system: 'tryton',
                  destination_entity: 'product.template')
            .and_return(
          ExternalIntegration::Data.new(
              destination_system:'tryton',
              destination_entity:'product.template',
              destination_id:'7'))

        expect(ExternalIntegration::Data).to receive(:first)
            .with(source_system: 'mybooking', 
                source_entity: 'product', 
                source_id: 'SK-EXTRA',
                destination_system: 'tryton',
                  destination_entity: 'product.template')
            .and_return(
          ExternalIntegration::Data.new(
              destination_system:'tryton',
              destination_entity:'product.template',
              destination_id:'8'))            

        # Mock to query ::Yito::Model::Booking::BookingCategory do return the expect product 'SK'
        expect(::Yito::Model::Booking::BookingCategory).to receive(:get)
            .with('SK')
            .and_return(::Yito::Model::Booking::BookingCategory.new(
              code: 'SK',
              name: 'Kayak',
              price_definition: price_definition_detailed_7_days))    

        # Do the process
        tryton_lines = booking_1_line_no_extras_10_days.lines_to_tryton

        # Check expectation
        expect(tryton_lines).to eql(expected)

    end

    #
    # Booking with 1 line and 1 extra for 9 days
    #
    it "booking with 1 line and 1 extra (unitary) for 9 days to tryton" do
      
        expected = [{
            "product" => 7,
            "description" => 'Kayak (7 días)',
            "gross_unit_price_w_tax" => {
              "__class__" => "Decimal",
              "decimal" => "70.00"
            },
            "quantity" => 3
          },
          {
            "product" => 8,
            "description" => 'Kayak (día extra)',
            "gross_unit_price_w_tax" => {
              "__class__" => "Decimal",
              "decimal" => "10.00"
            },
            "quantity" => 6
          },
          {
            "product" => 9,
            "description" => 'Toldo',
            "gross_unit_price_w_tax" => {
              "__class__" => "Decimal",
              "decimal" => "135.00"
            },
            "quantity" => 1
          }                        
        ]

        # Mock to query ExternalIntegration::Data to return the expected code
        # for the products 'SK-7' and 'SK-EXTRA'
        expect(ExternalIntegration::Data).to receive(:first)
            .with(source_system: 'mybooking', 
                source_entity: 'product', 
                source_id: 'SK-7',
                destination_system: 'tryton',
                  destination_entity: 'product.template')
            .and_return(
          ExternalIntegration::Data.new(
              destination_system:'tryton',
              destination_entity:'product.template',
              destination_id:'7'))

        expect(ExternalIntegration::Data).to receive(:first)
            .with(source_system: 'mybooking', 
                source_entity: 'product', 
                source_id: 'SK-EXTRA',
                destination_system: 'tryton',
                  destination_entity: 'product.template')
            .and_return(
          ExternalIntegration::Data.new(
              destination_system:'tryton',
              destination_entity:'product.template',
              destination_id:'8'))            

        expect(ExternalIntegration::Data).to receive(:first)
            .with(source_system: 'mybooking', 
                source_entity: 'product', 
                source_id: 'toldo',
                destination_system: 'tryton',
                  destination_entity: 'product.template')
            .and_return(
          ExternalIntegration::Data.new(
              destination_system:'tryton',
              destination_entity:'product.template',
              destination_id:'9'))

        # Mock to query ::Yito::Model::Booking::BookingCategory do return the expect product 'SK'
        expect(::Yito::Model::Booking::BookingCategory).to receive(:get)
            .with('SK')
            .and_return(::Yito::Model::Booking::BookingCategory.new(
              code: 'SK',
              name: 'Kayak',
              price_definition: price_definition_detailed_7_days))    

        expect(::Yito::Model::Booking::BookingExtra).to receive(:get)
            .with('toldo')
            .and_return(::Yito::Model::Booking::BookingCategory.new(
              code: 'toldo',
              name: 'Toldo',
              price_definition: price_definition_unitary))                

        # Do the process
        tryton_lines = booking_1_line_1_extra_unitary_9_days.lines_to_tryton

        # Check expectation
        expect(tryton_lines).to eql(expected)

    end

    #
    # Booking with 1 line and 1 extra (detailed) for 11 days
    #
    it "booking with 1 line and 1 extra (detailed) for 11 days to tryton" do
      
        expected = [{
            "product" => 7,
            "description" => 'Kayak (7 días)',
            "gross_unit_price_w_tax" => {
              "__class__" => "Decimal",
              "decimal" => "70.00"
            },
            "quantity" => 3
          },
          {
            "product" => 8,
            "description" => 'Kayak (día extra)',
            "gross_unit_price_w_tax" => {
              "__class__" => "Decimal",
              "decimal" => "10.00"
            },
            "quantity" => 12
          },                       
          {
            "product" => 10,
            "description" => 'Cubre PRO (7 días)',
            "gross_unit_price_w_tax" => {
              "__class__" => "Decimal",
              "decimal" => "70.00"
            },
            "quantity" => 1
          },
          {
            "product" => 11,
            "description" => 'Cubre PRO (día extra)',
            "gross_unit_price_w_tax" => {
              "__class__" => "Decimal",
              "decimal" => "10.00"
            },
            "quantity" => 4
          }
        ]

        # Mock to query ExternalIntegration::Data to return the expected code
        # for the products 'SK-7' and 'SK-EXTRA'
        expect(ExternalIntegration::Data).to receive(:first)
            .with(source_system: 'mybooking', 
                source_entity: 'product', 
                source_id: 'SK-7',
                destination_system: 'tryton',
                  destination_entity: 'product.template')
            .and_return(
          ExternalIntegration::Data.new(
              destination_system:'tryton',
              destination_entity:'product.template',
              destination_id:'7'))

        expect(ExternalIntegration::Data).to receive(:first)
            .with(source_system: 'mybooking', 
                source_entity: 'product', 
                source_id: 'SK-EXTRA',
                destination_system: 'tryton',
                  destination_entity: 'product.template')
            .and_return(
          ExternalIntegration::Data.new(
              destination_system:'tryton',
              destination_entity:'product.template',
              destination_id:'8'))            

        expect(ExternalIntegration::Data).to receive(:first)
            .with(source_system: 'mybooking', 
                source_entity: 'product', 
                source_id: 'cubre_pro-7',
                destination_system: 'tryton',
                  destination_entity: 'product.template')
            .and_return(
          ExternalIntegration::Data.new(
              destination_system:'tryton',
              destination_entity:'product.template',
              destination_id:'10'))

        expect(ExternalIntegration::Data).to receive(:first)
            .with(source_system: 'mybooking', 
                source_entity: 'product', 
                source_id: 'cubre_pro-EXTRA',
                destination_system: 'tryton',
                  destination_entity: 'product.template')
            .and_return(
          ExternalIntegration::Data.new(
              destination_system:'tryton',
              destination_entity:'product.template',
              destination_id:'11'))            

        # Mock to query ::Yito::Model::Booking::BookingCategory do return the expect product 'SK'
        expect(::Yito::Model::Booking::BookingCategory).to receive(:get)
            .with('SK')
            .and_return(::Yito::Model::Booking::BookingCategory.new(
              code: 'SK',
              name: 'Kayak',
              price_definition: price_definition_detailed_7_days))    

        expect(::Yito::Model::Booking::BookingExtra).to receive(:get)
            .with('cubre_pro')
            .and_return(::Yito::Model::Booking::BookingCategory.new(
              code: 'cubre_pro',
              name: 'Cubre PRO',
              price_definition: price_definition_detailed_7_days))                

        # Do the process
        tryton_lines = booking_1_line_1_extra_detailed_11_days.lines_to_tryton
  
        # Check expectation
        expect(tryton_lines).to eql(expected)

    end

  end	

end	