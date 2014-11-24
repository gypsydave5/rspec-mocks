require "spec_helper"

RSpec.describe "Modifying invoked expectations" do
  context "should_receive" do
    include_context "with syntax", [:should, :expect]

    shared_examples_for "a customization on an invoked expectation" do |customization_method|
      let(:method_to_inspect) { :foo }
      it "raises when the #{customization_method} method is called, indicating the expectation has already been invoked" do
        o = double(method_to_inspect => nil)
        expect {
          o.should_receive(method_to_inspect).__send__(customization_method, o.__send__(method_to_inspect))
        }.to raise_error(
          RSpec::Mocks::MockExpectationAlreadyInvokedError,
          /#{Regexp.escape(o.inspect)}.*:#{method_to_inspect}.*#{customization_method}/
        )
      end
    end

    it_behaves_like "a customization on an invoked expectation", :with
    it_behaves_like "a customization on an invoked expectation", :and_return
    it_behaves_like "a customization on an invoked expectation", :and_raise
    it_behaves_like "a customization on an invoked expectation", :and_throw
    it_behaves_like "a customization on an invoked expectation", :and_yield
    it_behaves_like "a customization on an invoked expectation", :exactly
    it_behaves_like "a customization on an invoked expectation", :at_least
    it_behaves_like "a customization on an invoked expectation", :at_most
  end
end
