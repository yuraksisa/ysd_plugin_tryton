require 'spec_helper'
require 'shared_order'
require "ysd_plugin_tryton/model/ysd_md_tryton_order_extension"
require 'date'
require 'bigdecimal'

describe YsdPluginTryton::OrderExtension do

  describe ".lines_to_tryton" do

    include_context "shared order"

    it "return 1 line to tryton" do
      
        expected = [{
          "product" => 2,
          "description" => 'Excusión Cales Coves (Adulto)',
          "gross_unit_price_w_tax" => {
            "__class__" => "Decimal",
            "decimal" => "50.00"
          },
          "quantity" => 1
        },
        {
          "product" => 3,
          "description" => 'Excusión Cales Coves (Niño 12 a 14 años)',
          "gross_unit_price_w_tax" => {
            "__class__" => "Decimal",
            "decimal" => "35.00"
          },
          "quantity" => 1
        },        
        ]

        # Mock to query ExternalIntegration::Data to return the expected code
        # for the product 'SK'
        expect(ExternalIntegration::Data).to receive(:first)
            .with(source_system: 'mybooking', 
            	  source_entity: 'product', 
            	  source_id: 'COVES-1',
            	  destination_system: 'tryton',
                  destination_entity: 'product.template')
            .and_return(
        	ExternalIntegration::Data.new(
        	    destination_system:'tryton',
        	    destination_entity:'product.template',
        	    destination_id:'2'))

        expect(ExternalIntegration::Data).to receive(:first)
            .with(source_system: 'mybooking', 
                source_entity: 'product', 
                source_id: 'COVES-2',
                destination_system: 'tryton',
                  destination_entity: 'product.template')
            .and_return(
          ExternalIntegration::Data.new(
              destination_system:'tryton',
              destination_entity:'product.template',
              destination_id:'3'))

        # Do the process
        tryton_lines = order_2_lines_different_price_type.lines_to_tryton

        # Check expectation
        expect(tryton_lines).to eql(expected)

    end

  end	

end	