
describe "`alias_method` matcher" do
  describe "klass" do
    let(:klass) do
      Class.new do
        def one; end
        alias_method :one1, :one

        def two; end
        alias two2 two
      end
    end

    subject { klass.new }

    it { is_expected.to alias_method(:one1, :one) }
    it { is_expected.to alias_method(:two2, :two) }
  end
end
