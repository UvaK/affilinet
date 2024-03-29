require 'rubygems'
gem 'rubyjedi-soap4r'
require 'soap_mapping_object_extension'
require 'soap/wsdlDriver'

class Affilinet

  # create a new webservice for each wsdl
  {
    :product => '/V2.0/ProductServices.svc?wsdl',
    :account => '/V2.0/PublisherInbox.svc?wsdl',
    :statistics => '/V2.0/PublisherStatistics.svc?wsdl',
    :program_list => '/V2.0/PublisherProgram.svc?wsdl'
  }.each do |key, wsdl|
    define_method(key) do
      Affilinet::WebService.new(wsdl, @user, @password, @base_url, @web_service_type)
    end
  end

  # set the base_url and credentials
  #
  def initialize(user, password, options = {})
    @base_url = options[:developer] ? 'https://developer-api.affili.net' : 'https://api.affili.net'
    @user = user
    @password = password
    @web_service_type  = options[:web_service_type] || 'Publisher'
  end

  class WebService

    def initialize(wsdl, user, password, url, type)
      @wsdl = wsdl
      @user = user
      @password = password
      @base_url = url
      @web_service_type = type
    end

    # checks against the wsdl if method is supported and raises an error if not
    #
    def method_missing(method, *args)
      if get_driver.respond_to?(api_method(method))
        arguments = { 'CredentialToken' => get_valid_token, "#{method.to_s.camelize}RequestMessage" => args.first }
        res = get_driver.send(api_method(method), arguments)
        res
      else
        super
      end
    end

    protected

    # only return a new driver if no one exists already
    #
    def get_driver
      @driver ||= soap_driver(@wsdl)
    end

    def soap_driver(wsdl)
      driver = SOAP::WSDLDriverFactory.new(@base_url + wsdl).create_rpc_driver
      driver.wiredump_dev = STDOUT if $DEBUG
      driver.options['protocol.http.ssl_config.verify_mode'] = OpenSSL::SSL::VERIFY_NONE
      driver
    end

    # returns actual token or a new one if expired
    #
    def get_valid_token
      return @token if (@token and (@created > 20.minutes.ago))
      @token = soap_driver("/V2.0/Logon.svc?wsdl").logon({
          :Username => @user,
          :Password => @password,
          :WebServiceType => @web_service_type,
          :DeveloperSettings => { :SandboxPublisherID => 403233 }
        })
      @created = Time.now
      @token
    end

    # handles the special name case of getSubIDStatistics
    #
    def api_method(method)
      method = method.to_s.camelize
      method == "GetSubIdStatistics" ? "GetSubIDStatistics" : method
    end

  end
end
