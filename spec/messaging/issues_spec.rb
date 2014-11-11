require 'spec_helper'

describe Dyn::Messaging::Client do

  describe "issues()" do
    subject { @dyn.issues }
    it_should_behave_like "a collection", "reports/issues"
  end

end