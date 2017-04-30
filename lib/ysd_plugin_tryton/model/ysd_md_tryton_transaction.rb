require 'faraday' unless defined?Faraday
require 'json'
require 'base64'

module YsdPluginTryton
  #
  # It's a template to execute Tryton transactions
  #
  class YsdMdTrytonTransaction


    def initialize(url, database, username, password)
      @url = url
      @database = database
      @username = username
      @password = password
      @uri = "#{@url}/#{@database}/"
    end

    protected

    #
    # Do a transaction wrapped in an connection to Tryton
    #
    # Example: 
    #
    #   do_transaction do |conn, session|
    #
    #     
    #   end
    #   
    # Return an String with an error message if the connection or the login to Tryton was not possible
    #
    def do_transaction

      # Create an HTTP connection to Tryton
      connect_result = connect 
 
      if connect_result[:done] 
        conn = connect_result[:response]
        # Log in
        login_result = login(conn) 
        if login_result[:done] 
          session = login_result[:response]
          # Do the transaction
          yield conn, session
          # Log out 
          logout(conn) 
          return {done: true, response: "Transaction processed"}
        else
          return {done: false, response: login_result[:response]}
        end
      else
        return {done: false, response: "It can not create an HTTP connection or the URL #{@uri} was not valid"}
      end  

    end  

    # -----------------------------------------------------------------------------------------

    # 
    # Create an HTTP connection to the Tryton database
    #
    # Returns a Faraday::Connection
    #
    def connect
      if @uri =~ URI::regexp
        conn = Faraday.new(@uri)
        return {done: true, response: conn}
      else
        return {done: false, response: "Invalid URL #{@uri}"}
      end
    end

    #
    # Login to tryton
    #
    # Returns true is logged in
    #
    def login(conn)

      response = conn.post do |req| 
        req.headers['Content-Type'] = 'application/json' 
        req.body = <<-BODY
           { 
             "method":"common.db.login",
             "params":[
                  "#{@username}",
                  "#{@password}"
              ] 
           }
        BODY
      end

      if response.status == 200
        response_body = JSON.parse(response.body)
        if response_body.has_key?('result')
          if response_body['result'].nil?
            return {done: false, response: 'Login error. Invalid user/password'}
          else  
            user_id = response_body['result'].first
            session_id = response_body['result'].last
            session = Base64.encode64("api:#{user_id}:#{session_id}").gsub("\n","")
            return {done: true, response: session}
          end  
        elsif response_body.has_key?('error')
          return {done: false, response: "Login error. #{response_body['error']}"}
        end
      else
        return {done: false, response: "Login error. HTTP connection response is #{response.status}"}
      end

    end

    #
    # Logout to tryton
    #
    def logout(conn)

      response = conn.post do |req| 
        req.headers['Content-Type'] = 'application/json' 
        req.body = <<-BODY
          { 
            "method":"common.db.logout",
            "params":[] 
          }
        BODY
      end

    end  
    

  end	
end

