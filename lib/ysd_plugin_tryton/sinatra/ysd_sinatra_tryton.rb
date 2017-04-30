module YsdPluginTryton
  module Sinatra

    def self.registered(app)

      # Add the local folders to the views and translations     
      app.settings.views = Array(app.settings.views).push(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'views')))
      app.settings.translations = Array(app.settings.translations).push(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'i18n')))       

        
      #
      # Tryton Setup 
      #
      app.get '/admin/tryton/setup', :allowed_usergroups => ['booking_manager','staff'] do

        load_page :tryton_setup

      end	

      #
      # Pending charges
      #
      app.get '/admin/tryton/pending-charges', :allowed_usergroups => ['booking_manager','staff'] do 

        @data = Payments::Charge.tryton_pending 
        load_page :tryton_pending_charges

      end
      
      #
      # Sends a charge to Tryton
      #
      app.post '/admin/tryton/charge/:id', :allowed_usergroups => ['booking_manager','staff'] do

        response = YsdPluginTryton::Integration.create_deposit(params[:id])

        if response[:done]
          redirect '/admin/tryton/pending-charges', notice: 'Depósito registrado'
        else 
          redirect '/admin/tryton/pending-charges', error: 'Error registrando depósito'
        end
        
      end

    end

  end
end