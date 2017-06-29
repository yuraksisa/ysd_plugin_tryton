module YsdPluginTryton
  module ChargeExtension

    def self.extended(model)
      model.extend ClassMethods
    end

    module ClassMethods

      def tryton_pending
         Payments::Charge.by_sql { |b| [tryton_pending_sql(b)] } 
      end

      private

      def tryton_pending_sql(b)
      	sql = <<-QUERY
      	  SELECT #{b.*} 
      	  FROM #{b}
      	  WHERE #{b.date} > '2017-01-01' and 
      	        #{b.status} = 4 and
      	        #{b.id} not in (select source_id from int_data where source_system='mybooking' and 
      	        	              source_entity='charge' and destination_system = 'tryton' and destination_entity='sale.deposit') and
                #{b.id} not in (select source_id from int_data where source_system='mybooking' and 
                                source_entity='charge' and destination_system = 'tryton' and destination_entity='sale.sale')
          ORDER BY #{b.date} desc
        QUERY
      end

    end

  end
  Payments::Charge.extend(ChargeExtension)
end
