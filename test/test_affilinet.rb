require 'helper'

class TestAffilinet < ActiveSupport::TestCase


  context "The Affilinet interface" do

    setup do
      #$DEBUG = true
      @dev_env = true
      @user = 'Users.X.XXXX' # !!! Replace with your developer account credentials
      @password = 'XXXX' # !!! Replace with your developer account credentials

      @client = HTTPClient.new(nil, "test")
      @client.debug_dev = ''

      # proxy the wsdl requests
      mock.proxy(HTTPClient).new(nil,"WSDL4R").times(any_times)
      # proxy any soap request
      mock.proxy(HTTPClient).new(nil,"RUBYJEDI-SOAP4R/1.5.8").times(any_times)
    end

    context "API class" do

      should "authenticate a user" do
        api = Affilinet.new(@user, @password, :developer => @dev_env).statistics
        token = api.send(:get_valid_token)
        assert_not_nil token
        assert token.is_a?(String)
      end

    end

    context "Statistics module" do

      setup do
        @get_sub_id_fields = [ :commission, :confirmed, :date, :number, :price, :subId, :transaction, :transactionStatus ]
      end

      should 'call method get_sub_id_statistics' do
        webs = Affilinet.new(@user, @password, :developer => @dev_env ).statistics

        # make sure the functions are called
        mock.proxy(webs).method_missing(:get_sub_id_statistics, anything)

        res = webs.get_sub_id_statistics({
            :StartDate => SOAP::SOAPDateTime.new(Date.yesterday),
            :EndDate => SOAP::SOAPDateTime.new(Date.yesterday),
            :ValuationType => 'DateOfRegistration',
            :ProgramIds => [],
            :MaximumRecords => 2,
            :ProgramTypes => 'All',
            :TransactionStatus => 'All'
          }.with_indifferent_access)

        assert_equal(2, res.count)

        # check if each response item is conform
        res.each do |record|
          @get_sub_id_fields.each do |val|
            assert_respond_to record, val, "#{val} did not respond"
            assert_instance_of(String, record.send(val))
          end

          [ :commission, :confirmed, :price].each do |val|
            assert_match(/[0-9]+\.[0-9]+/, record.send(val))
          end
        end
      end

      should 'call method get_sales_leads_statistics' do
        webs = Affilinet.new(@user, @password, :developer => @dev_env ).statistics

        # make sure the functions are called
        mock.proxy(webs).method_missing(:get_sales_leads_statistics, anything)

        res = webs.get_sales_leads_statistics({
            :StartDate => SOAP::SOAPDateTime.new('01/01/2009'),
            :EndDate => SOAP::SOAPDateTime.new('01/01/2009'),
            :ValuationType => 'DateOfRegistration',
            :ProgramIds => [],
            :MaximumRecords => 2,
            :ProgramTypes => 'All',
            :TransactionStatus => 'All',
            :SubId => 'bla'
          }.with_indifferent_access)
        assert_equal(0, res.count)
      end

      should 'call method get_sub_id_statistics (response mocked)' do
        webs = Affilinet.new(@user, @password, :developer => @dev_env ).statistics

        # set xml body response and http-header from factory
        @client.test_loopback_http_response << File.read('./' + File.dirname(__FILE__) + '/fixtures/get_sub_id_statistics.soap_response')
        any_instance_of(Affilinet::WebService) do |o|
            mock(o).get_valid_token { "test_auth_token" }
        end

        # mock response from affilinet
        mock(HTTPClient).new(nil,"RUBYJEDI-SOAP4R/1.5.8").times(any_times) { @client }

        # make sure the functions are called
        mock.proxy(webs).method_missing('get_sub_id_statistics', anything)

        res = webs.get_sub_id_statistics({
            :StartDate => SOAP::SOAPDateTime.new('01/07/2010'),
            :EndDate => SOAP::SOAPDateTime.new('01/07/2010'),
            :ValuationType => 'DateOfRegistration',
            :ProgramIds => [],
            :MaximumRecords => 1000,
            :ProgramTypes => 'All',
            :TransactionStatus => 'All'
          }.with_indifferent_access)
        assert_equal(2, res.count)
      end

      should 'not respond when wrong module is used for function call' do
        webs = Affilinet.new(@user, @password, :developer => @dev_env ).product

        mock.proxy(webs).method_missing(:get_sub_id_statistics, anything)
        assert_raise(NoMethodError) do
          res = webs.get_sub_id_statistics({
              :StartDate => SOAP::SOAPDateTime.new('01/07/2010'),
              :EndDate => SOAP::SOAPDateTime.new('01/07/2010'),
              :ValuationType => 'DateOfRegistration',
              :ProgramIds => [],
              :MaximumRecords => 1,
              :ProgramTypes => 'All',
              :TransactionStatus => 'All'
            }.with_indifferent_access)
        end
      end

      should 'call method get_program_statistics' do
        webs = Affilinet.new(@user, @password, :developer => @dev_env ).statistics

        # make sure the functions are called
        mock.proxy(webs).method_missing(:get_program_statistics, anything)

        res = webs.get_program_statistics({
            :StartDate => SOAP::SOAPDateTime.new(Date.yesterday),
            :EndDate => SOAP::SOAPDateTime.new(Date.yesterday),
            :ValuationType => 'DateOfRegistration',
            :ProgramIds => [],
            :MaximumRecords => 2,
            :ProgramTypes => 'All',
            :ProgramStatus => 'All'
          }.with_indifferent_access)
        assert_equal(0, res.count)
      end
    end

    # TODO: test supported methods
    context "Account module" do

    end

    # TODO: test supported methods
    context "Product module" do

    end

    # TODO: test supported methods
    context "ProgramList module" do

    end
  end
end
