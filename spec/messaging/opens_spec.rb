require 'spec_helper'

describe Dyn::Messaging::Client do

  describe "opens()" do
    subject { @dyn.opens }
    it_should_behave_like "a collection", "reports/opens"
    it_should_behave_like "a unique collection", "reports/opens"
  end

end