
describe "`.include_dir_context` at root" do
  include_dir_context __dir__
  use_method_discovery :m

  subject { public_send(m) }

  describe "#global_sign" do
    it { is_expected.to eq "root" }
  end

  describe "#local_sign" do
    it { expect { subject }.to raise_error(NoMethodError) }
  end
end
