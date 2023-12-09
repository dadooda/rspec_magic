
module RSpecMagic
  module Unstable
  end
end

Dir[File.expand_path("../unstable/**/*.rb", __FILE__)].each { |fn| require fn }
