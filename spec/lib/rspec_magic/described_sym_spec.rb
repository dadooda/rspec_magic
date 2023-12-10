
describe "#described_sym" do
  use_method_discovery :m

  context "when the class is named like …" do
    class CSVRow; end

    class PageTitle
      class Style
      end
    end

    subject { public_send(m) }

    describe CSVRow do
      it { is_expected.to eq :csv_row }
    end

    describe PageTitle do
      it { is_expected.to eq :page_title }
    end

    describe PageTitle::Style do
      it { is_expected.to eq :"page_title/style" }
    end
  end
end
