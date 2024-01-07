
require "json"

describe ".context_when" do
  context "when default" do
    context_when a: 1, "b" => 2, x: "y" do
      description = self.description
      it { expect([a, b, x]).to eq [1, 2, "y"] }
      it { expect { c }.to raise_error(NameError, /^undefined local variable or method `c'/) }
      it { expect(description).to eq 'when { a: 1, "b" => 2, x: "y" }' }
    end
  end

  context "when customized" do
    def self._context_when_formatter(h)
      "when #{h.to_json}"
    end

    describe "intermediate context" do
      context_when a: 1, x: "y" do
        description = self.description
        it { expect([a, x]).to eq [1, "y"] }
        it { expect(description).to eq 'when {"a":1,"x":"y"}' }
      end
    end
  end # context "when customized"

  describe "doc examples" do
    describe "*" do
      context_when name: "Joe", age: 25 do
        it do
          expect([name, age]).to eq ["Joe", 25]
        end
      end

      context "when { name: \"Joe\", age: 25 }" do
        let(:name) { "Joe" }
        let(:age) { 25 }
        it do
          expect([name, age]).to eq ["Joe", 25]
        end
      end
    end
  end # describe "doc examples"
end
