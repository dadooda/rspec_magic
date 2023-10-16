
require "json"

# OPTIMIZE: Retro-check neighbours.
describe ".context_when" do
  context "when default" do
    context_when a: 1, "b" => 2, x: "y" do
      description = self.description
      it { expect(description).to eq 'when { a: 1, "b" => 2, x: "y" }' }
      it { expect { c }.to raise_error(NameError, /^undefined local variable or method `c'/) }
      it { expect([a, b, x]).to eq [1, 2, "y"] }
    end
  end

  context "when customized" do
    def self._context_when_formatter(h)
      "when #{h.to_json}"
    end

    context_when a: 1, x: "y" do
      description = self.description
      it { expect(description).to eq 'when {"a":1,"x":"y"}' }
      it { expect([a, x]).to eq [1, "y"] }
    end
  end
end
