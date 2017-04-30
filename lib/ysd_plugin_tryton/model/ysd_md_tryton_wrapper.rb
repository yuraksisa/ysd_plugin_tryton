require 'faraday' unless defined?Faraday
require 'json'
require 'base64'

module YsdPluginTryton
  #
  # Status:
  #
  #  not_connected
  #  connection_error
  #  login_error
  #  logged_in
  #  logged_out
  #
  class YsdMdTrytonWrapper < YsdMdTrytonTransaction

    #
    # Creates a deposit for a charge
    #
    # @return [Hash] with two keys: result and detail
    #
    #    :result        : 'ok' | 'error'
    #    :charge_id     : The id of the deposit if result == 'ok'
    #    :error_message : The error message if result == 'error'
    #
    def create_deposit(charge_request)

      result = {}

      transaction_result = do_transaction do |conn, session|

        p "Tryton create_deposit request: #{charge_request.to_json}"

        # Do the request
        response = conn.post do |req|
          req.headers['Content-Type'] = 'application/json'
          req.headers['Authorization'] = "Session #{session}"
          req.body = charge_request.to_json
        end

        # Process the response
        if response.status == 200 # Operation processed
          response_body = JSON.parse(response.body)
          p "Tryton create_deposit response status: #{response.status} body: #{response.body.inspect}"
          if response_body.has_key?('error')
            result[:done] = false
            result[:response] = response_body['error']
          elsif response_body.has_key?('result')
            result[:done] = true
            if response_body['result'].is_a?(Hash)
              result[:response] = response_body['result']
            else
              result[:response] = response_body['result']
            end  
          end  
        else # Operation not processed
          result[:done] = false
          result[:response] = "Deposit creation HTTP Error #{response.status}"
          p "Tryton create_deposit not processed. status: #{response.status} body: #{response_body.inspect}"
        end
          
      end

      # Retrive the error from the transaction block

      if result.empty? and !transaction_result[:done]
        result[:done] = false
        result[:response] = transaction_result[:response]
      end

      return result

    end

  end
end