require 'spec_helper'

describe Dyn::Messaging::Client do

  describe "complaints()" do
    subject { @dyn.complaints }
    it_should_behave_like "a collection", "reports/complaints"
  end

end