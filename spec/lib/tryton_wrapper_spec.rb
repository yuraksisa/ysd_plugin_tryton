require 'spec_helper'
require "ysd_plugin_tryton/model/ysd_md_tryton_transaction"
require "ysd_plugin_tryton/model/ysd_md_tryton_wrapper"

describe YsdPluginTryton::YsdMdTrytonWrapper do

  describe ".create_deposit" do

    it "does invalid URI" do

      tryton_wrapper = YsdPluginTryton::YsdMdTrytonWrapper.new("the_url", "the_database", "the_username", "the_password")

      expect(tryton_wrapper).to receive(:connect).and_return({done: false, response: "Invalid URI the_url/the_database/"})
 
      result = tryton_wrapper.create_deposit({})

    end

    it "does not faraday connect" do
    
       tryton_wrapper = YsdPluginTryton::YsdMdTrytonWrapper.new("http://kiko.koko", "the_database", "the_username", "the_password")

       expect(tryton_wrapper).to receive(:connect).and_return({done: false, response: 'It can not create an HTTP connection or the URL http://kiko.koko/the_database/ was not valid'})

       result = tryton_wrapper.create_deposit({})

       expect(result).to eql({done: false, response: 'It can not create an HTTP connection or the URL http://kiko.koko/the_database/ was not valid' })

    end

    it "does not login : HTTP error" do

       tryton_wrapper = YsdPluginTryton::YsdMdTrytonWrapper.new("http://google.com", "the_database", "the_username", "the_password")

       result = tryton_wrapper.create_deposit({})

       expect(result).to eql({done: false, response: 'Login error. HTTP connection response is 404' })

    end

    it "does not login : invalid username/password" do
    
       tryton_wrapper = YsdPluginTryton::YsdMdTrytonWrapper.new("http://google.com", "the_database", "the_username", "the_password")
    
       expect(tryton_wrapper).to receive(:login).and_return(done: false, response: 'Login error. Invalid user/password')

       result = tryton_wrapper.create_deposit({})
    
       expect(result).to eql({done: false, response: 'Login error. Invalid user/password' })
    
    end

    it "does not login : tryton error response" do

       tryton_wrapper = YsdPluginTryton::YsdMdTrytonWrapper.new("http://google.com", "the_database", "the_username", "the_password")
    
       expect(tryton_wrapper).to receive(:login).and_return(done: false, response: 'Login error. Tryton Error')

       result = tryton_wrapper.create_deposit({})

       expect(result).to eql({done: false, response: 'Login error. Tryton Error'})

    end	

    it "does login, fails creating deposit" do

       tryton_wrapper = YsdPluginTryton::YsdMdTrytonWrapper.new("http://google.com", "the_database", "the_username", "the_password")
    
       faraday_connection = double("faraday_connection")

       expect(tryton_wrapper).to receive(:connect).and_return(done: true, response: faraday_connection)
       expect(tryton_wrapper).to receive(:login).and_return(done: true, response: '1234567890')
       # Two returns : The first the create_deposit and the second the logout
       expect(faraday_connection).to receive(:post).and_return(OpenStruct.new({'status' => 200, 'body' => '{"error":"Error"}'}),
       	                                                       OpenStruct.new({'status' => 200}))

       result = tryton_wrapper.create_deposit({})

       expect(result).to eql({done: false, response: 'Error'})

    end	

    it "does login, creates deposit" do

       tryton_wrapper = YsdPluginTryton::YsdMdTrytonWrapper.new("http://google.com", "the_database", "the_username", "the_password")
    
       faraday_connection = double("faraday_connection")

       expect(tryton_wrapper).to receive(:connect).and_return(done: true, response: faraday_connection)
       expect(tryton_wrapper).to receive(:login).and_return(done: true, response: '1234567890')
       # Two returns : The first the create_deposit and the second the logout
       expect(faraday_connection).to receive(:post).and_return(OpenStruct.new({'status' => 200, 'body' => '{"result":{"sale.deposit":17}}'}),
       	                                                       OpenStruct.new({'status' => 200}))

       result = tryton_wrapper.create_deposit({})

       expect(result).to eql({done: true, response: {"sale.deposit"=>17}})

    end	

    it "does login, create sale (full payment)" do

       tryton_wrapper = YsdPluginTryton::YsdMdTrytonWrapper.new("http://google.com", "the_database", "the_username", "the_password")
    
       faraday_connection = double("faraday_connection")

       expect(tryton_wrapper).to receive(:connect).and_return(done: true, response: faraday_connection)
       expect(tryton_wrapper).to receive(:login).and_return(done: true, response: '1234567890')
       # Two returns : The first the create_deposit and the second the logout
       expect(faraday_connection).to receive(:post).and_return(OpenStruct.new({'status' => 200, 'body' => '{"result":{"sale.sale":17}}'}),
                                                               OpenStruct.new({'status' => 200}))

       result = tryton_wrapper.create_deposit({})

       expect(result).to eql({done: true, response: {"sale.sale" => 17}})

    end


  end
  
end	