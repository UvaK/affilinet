require 'active_support/all'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'affilinet'

# Replace XXX with your developer credentials
affi = Affilinet.new('Users.X.XXXX', 'XXX')

res = affi.statistics.get_sub_id_statistics({
    :StartDate => SOAP::SOAPDateTime.new(Date.yesterday),
    :EndDate => SOAP::SOAPDateTime.new(Date.yesterday),
    :ValuationType => 'DateOfRegistration',
    :ProgramIds => [],
    :MaximumRecords => 2,
    :ProgramTypes => 'All',
    :TransactionStatus => 'All'
  }.with_indifferent_access)


res.each do |row|
  p row
end

