# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{affilinet}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["adyard GmbH"]
  s.date = %q{2011-01-14}
  s.description = %q{The affilinet gem provides an interface to the affilinet webservice api.}
  s.email = %q{axel.kelting@adyard.de}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "affilinet.gemspec",
     "examples/example.rb",
     "lib/affilinet.rb",
     "lib/soap_mapping_object_extension.rb",
     "test/fixtures/AccountService.svc?wsdl",
     "test/fixtures/Logon.svc?wsdl",
     "test/fixtures/ProductServices.svc?wsdl",
     "test/fixtures/PublisherCreative.svc?wsdl",
     "test/fixtures/PublisherInbox.svc?wsdl",
     "test/fixtures/PublisherProgram.svc?wsdl",
     "test/fixtures/PublisherStatistics.svc?wsdl",
     "test/fixtures/get_sub_id_statistics.soap_response",
     "test/helper.rb",
     "test/test_affilinet.rb",
     "version"
  ]
  s.homepage = %q{http://github.com/adyard/affilinet}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Affilinet webservice interface}
  s.test_files = [
    "test/helper.rb",
     "test/test_affilinet.rb",
     "examples/example.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_runtime_dependency(%q<rubyjedi-soap4r>, [">= 1.5.8"])
      s.add_runtime_dependency(%q<httpclient>, [">= 0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_dependency(%q<rubyjedi-soap4r>, [">= 1.5.8"])
      s.add_dependency(%q<httpclient>, [">= 0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    s.add_dependency(%q<rubyjedi-soap4r>, [">= 1.5.8"])
    s.add_dependency(%q<httpclient>, [">= 0"])
  end
end

