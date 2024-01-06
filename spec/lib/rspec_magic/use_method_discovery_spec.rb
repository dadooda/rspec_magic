
describe ".use_method_discovery" do
  describe "doc examples" do
    describe do
      use_method_discovery :m

      subject { m }

      describe "#first_name" do
        it { is_expected.to eq :first_name }
      end

      describe ".some_stuff" do
        it { is_expected.to eq :some_stuff }
      end

      describe "GET some_action" do
        describe "intermediate context" do
          it { is_expected.to eq :some_action }   # (1)
        end
      end
    end
  end # describe "doc examples"
end
