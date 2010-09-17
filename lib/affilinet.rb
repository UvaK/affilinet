require 'rubygems'
gem 'soap4r'

module Affilinet
  require 'soap_mapping_object_extension'
  class API
    require 'soap/wsdlDriver'

    class << self
      attr_accessor :token

      # set the base_url and logon to affilinet to get the auth token
      #
      def init(user, password, options = {})
        @base_url = options[:developer] ? 'https://developer-api.affili.net' : 'https://api.affili.net'
        @user = user
        @password = password
        @token = nil
      end

      # only return a new driver if wsdl changed
      #
      def driver(wsdl)
        return @driver if @wsdl == wsdl
        @driver = SOAP::WSDLDriverFactory.new(@base_url + wsdl).create_rpc_driver
        @driver.wiredump_dev = STDOUT if $DEBUG
        @driver.options['protocol.http.ssl_config.verify_mode'] = OpenSSL::SSL::VERIFY_NONE
        @driver
      end

      def get_valid_token
        return @token if (@token and (@created > Time.now - 20.minutes))
        @token = driver("/V2.0/Logon.svc?wsdl").logon({
            :Username => @user,
            :Password => @password,
            :WebServiceType => 'Publisher',
            :DeveloperSettings => { :SandboxPublisherID => 403233 }
          })
        @created = Time.now
        @token
      end
    end
  end

  # base module for all soap requests
  #
  # TODO: summarize equal behaviour for returning response
  module WebService

    # executes the soap request
    #
    def request(method, options = {})
      arguments = { 'CredentialToken' => Affilinet::API.get_valid_token, "#{method.to_s.camelize}RequestMessage" => options }
      res = Affilinet::API.driver(@wsdl).send(api_method(method), arguments)
      res
    end

    # checks against the wsdl if method is supported and raises an error if not
    #
    def method_missing(method, args = {})
      if Affilinet::API.driver(@wsdl).respond_to?(api_method(method))
        request(method, args)
      else
        super
      end
    end

    # handles the special name case of getSubIDStatistics
    #
    def api_method(method)
      method = method.to_s.camelize
      method == "GetSubIdStatistics" ? "GetSubIDStatistics" : method
    end
  end

  # TODO: add product functions that need special treatment?
  module Product
    include WebService
    extend WebService

    @wsdl = '/V2.0/ProductServices.svc?wsdl'
  end

  # TODO: add account functions that need special treatment?
  module Account
    include WebService
    extend WebService

    @wsdl = '/V2.0/PublisherInbox.svc?wsdl'
  end

  module Statistics
    include WebService
    extend WebService

    @wsdl = '/V2.0/PublisherStatistics.svc?wsdl'
    
    def self.get_sub_id_statistics(options = {})
      request(:get_sub_id_statistics, options)

      #return_array(res.subIdStatisticsRecords.records, :subIdStatisticsRecord)
    end

    #def self.get_sales_leads_statistics(option = {})
    #  request(:get_sales_leads_statistics, options)
    #end
  end

  # TODO: add program_list functions that need special treatment
  module ProgramList
    include WebService
    extend WebService

    @wsdl = '/V2.0/PublisherProgram.svc?wsdl'
    
  end
end
