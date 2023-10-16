
describe "`alias_method` matcher" do
  describe "klass" do
    let(:klass) do
      Class.new do
        def is_one
        end
        alias_method :one?, :is_one
      end
    end

    subject { klass.new }

    it { is_expected.to alias_method(:one?, :is_one) }
  end
end
