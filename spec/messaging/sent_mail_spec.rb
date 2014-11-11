require 'spec_helper'

describe Dyn::Messaging::Client do

  describe "sent()" do
    subject { @dyn.sent_mail }
    it_should_behave_like "a collection", "reports/sent"
  end

end