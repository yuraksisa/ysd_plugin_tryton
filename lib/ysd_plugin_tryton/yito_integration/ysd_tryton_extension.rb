#
# MediaGallery Extension
#
module YsdPluginTryton

  class TrytonExtension < Plugins::ViewListener


    # ========= Installation =================

    # 
    # Install the plugin
    #
    def install(context={})

        SystemConfiguration::SecureVariable.first_or_create({:name => 'tryton.url'}, 
          {:value => '.', 
           :description => 'Tryton URL', 
           :module => :tryton_integration})

        SystemConfiguration::SecureVariable.first_or_create({:name => 'tryton.database'}, 
          {:value => '.', 
           :description => 'Tryton database', 
           :module => :tryton_integration})

        SystemConfiguration::SecureVariable.first_or_create({:name => 'tryton.username'}, 
          {:value => '.', 
           :description => 'Tryton username', 
           :module => :tryton_integration})                   

        SystemConfiguration::SecureVariable.first_or_create({:name => 'tryton.password'}, 
          {:value => '.', 
           :description => 'Tryton password', 
           :module => :tryton_integration})
        
        SystemConfiguration::SecureVariable.first_or_create({:name => 'tryton.sync_deposit'},
          {:value => 'false',
           :description => 'Setup the platform to sync deposits with Tryton',
           :module => :tryton_integration })

    end
  end
end          