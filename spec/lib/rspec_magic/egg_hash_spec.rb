
module RSpecMagic
  describe EggHash do
    include_dir_context __dir__

    context "when we're a root object" do
      use_method_discovery :m

      describe "#hatch" do
        [
          [[{}], {}],
          [
            [b: true, fl: 5.5, n: ["a+b", -> { 30 + 7 }]],
            { b: true, fl: 5.5, n: 37 },
          ],
        ].each do |args, expected|
          it do
            # Print expectation in a smart way already!
            h = described_class[*args]
            output = h.hatch
            expect([h, output]).to eq [h, expected]
          end
        end
      end

      describe "#inspect*" do
        [
          [[{}], "{}", "*"],
          [
            [{ sy1: true, :"sym 2" => 5.5, "str" => "Hey" }],
            "{ sy1: true, :\"sym 2\": 5.5, \"str\" => \"Hey\" }",
            "*",
          ],
        ].each do |args, exp_smt, exp_trd|
          it do
            output = described_class[*args].send(:inspect_smart)
            expect([args, output]).to eq [args, exp_smt]
          end
        end
      end
    end

    # AF: TODO: Fin2.
    # context "when we're a value" do
    # end

    describe "function methods" do
      use_method_discovery :m

      let(:obj) { described_class.new }

      describe "#format_sym" do
        [
          [:kk, "kk"],
          [:"", ":\"\""],
          [:"kk mkk", ":\"kk mkk\""],
        ].each do |input, expected|
          it { expect([input, obj.send(m, input)]).to eq [input, expected] }
        end
      end
    end
  end # describe
end
