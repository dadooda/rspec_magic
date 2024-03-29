
describe ".use_letset" do
  describe "straight usage" do
    use_letset :let_a, :attrs
    use_letset :let_d, :data

    # Same-level definition. Important case.
    let_a(:name) { "Joe" }

    let_d(:number) { 12 }

    describe "attrs" do
      let_a(:age) { 25 }

      describe "sub-context" do
        # Redefinition via `let`.
        let_a(:age) { 36 }
        let_a(:gender) { :male }
        it do
          expect(name).to eq "Joe"
          expect(age).to eq 36
          expect(gender).to eq :male
          expect(attrs).to eq(name: "Joe", age: 36, gender: :male)
        end
      end

      it do
        expect(name).to eq "Joe"
        expect(age).to eq 25
        expect(attrs).to eq(name: "Joe", age: 25)
      end
    end

    describe "data" do
      it do
        expect(number).to eq 12
        expect(data).to eq(number: 12)
      end
    end
  end

  describe "declarative (no block) usage" do
    use_letset :let_a, :attrs

    let_a(:name)

    subject { attrs }

    context "when no `let` value" do
      context "when additional other `let` value" do
        let_a(:age) { 25 }
        it { is_expected.to eq(age: 25) }
      end

      it do
        expect { name }.to raise_error RSpec::Core::ExampleGroup::WrongScopeError
        expect(attrs).to eq({})
      end
    end

    context "when `let`" do
      let(:name) { "Joe" }
      it { is_expected.to eq(name: "Joe") }
    end

    context "when `let_a`" do
      let_a(:name) { "Joe" }
      it { is_expected.to eq(name: "Joe") }
    end

    # Real-life thing follows, that's what we need declarative mode for.
    context_when name: "Joe" do
      context_when name: "Moe" do
        it { is_expected.to eq(name: "Moe") }
      end

      it { is_expected.to eq(name: "Joe") }
    end
  end # describe "declarative (no block) usage"

  describe "doc examples" do
    describe "EN" do
      describe do
        # Method is `let_a`. Collection is `attrs`.
        use_letset :let_a, :attrs

        # Declare `attrs` elements.
        let_a(:age)
        let_a(:name)

        subject { attrs }

        # None of the elements is set yet.
        it { is_expected.to eq({}) }

        # Set `name` and see it in the collection.
        context_when name: "Joe" do
          it { is_expected.to eq(name: "Joe") }

          # Add `age` and see both in the collection.
          context_when age: 25 do
            it { is_expected.to eq(name: "Joe", age: 25) }
          end
        end
      end
    end # describe "EN"

    describe "RU" do
      describe do
        # Метод -- `let_a`. Коллекция -- `attrs`.
        use_letset :let_a, :attrs

        # Декларируем переменные, которые составляют коллекцию `attrs`.
        let_a(:age)
        let_a(:name)

        subject { attrs }

        # Ни одна переменная пока не задана, поэтому коллекция будет пустой.
        it { is_expected.to eq({}) }

        # Задаём `name` и видим его в коллекции.
        context_when name: "Joe" do
          it { is_expected.to eq(name: "Joe") }

          # Задаём `age` и видим обе переменные в коллекции.
          context_when age: 25 do
            it { is_expected.to eq(name: "Joe", age: 25) }
          end
        end
      end
    end # describe "RU"
  end # describe "doc examples"
end
