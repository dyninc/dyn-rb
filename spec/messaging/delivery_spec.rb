require 'spec_helper'

describe Dyn::Messaging::Client do

  describe "delivery()" do
    subject { @dyn.delivery }
    it_should_behave_like "a collection", "reports/delivered"
  end

end