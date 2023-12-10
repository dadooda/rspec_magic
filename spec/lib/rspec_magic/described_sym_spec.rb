
describe "`#described_sym` and friends" do
  use_method_discovery :m

  class CSVRow; end

  class PageTitle
    class Style
    end
  end

  subject { public_send(m) }

  describe "#described_sym" do
    context "when the class is named like …" do
      describe CSVRow do
        it { is_expected.to eq :csv_row }
      end

      describe PageTitle do
        it { is_expected.to eq :page_title }
      end

      describe PageTitle::Style do
        # NOTE: That's how it works. Not sure if it's utterly useful though.
        it { is_expected.to eq :"page_title/style" }
      end
    end # context "when the class is named like …"
  end

  # Just ping it briefly.
  describe "#me" do
    describe CSVRow do
      it { is_expected.to eq :csv_row }
    end
  end
end
