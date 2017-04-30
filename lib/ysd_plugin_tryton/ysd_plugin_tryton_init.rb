require 'ysd-plugins' unless defined?Plugins::Plugin

Plugins::SinatraAppPlugin.register :tryton do

   name=        'tryton'
   author=      'yurak sisa'
   description= 'tryton'
   version=     '0.1'
   sinatra_extension YsdPluginTryton::Sinatra 
   hooker YsdPluginTryton::TrytonExtension

end