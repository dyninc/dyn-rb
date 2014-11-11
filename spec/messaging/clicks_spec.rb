require 'spec_helper'

describe Dyn::Messaging::Client do

  describe "clicks()" do
    subject { @dyn.clicks }
    it_should_behave_like "a collection", "reports/clicks"
    it_should_behave_like "a unique collection", "reports/clicks"
  end

end