
# 🟠RSpecMagic

👉Ёмкий заголовок, варианты.

<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Что это?](#что-это)
- [Установка](#установка)
- [Применение](#применение)
- [🟠Фичи](#фичи)
  - [`alias_method`](#alias_method)
  - [`context_when`](#context_when)
  - [`described_sym`](#described_sym)
  - [`include_dir_context`](#include_dir_context)
  - [`use_letset`](#use_letset)
  - [`use_method_discovery`](#use_method_discovery)
- [Copyright](#copyright)

<!-- /code_chunk_output -->

## Что это?

*An English version of this text is also available: [README.md](README.md).*

RSpecMagic — набор расширений для написания более компактных и ёмких RSpec-тестов.

## Установка

Добавляем в `Gemfile` нашего проекта:

```ruby
gem "rspec_magic"
#gem "rspec_magic", git: "https://github.com/dadooda/rspec_magic"
```

## Применение

Там и сям, обычно это `spec_helper.rb`:

```ruby
require "rspec_magic/stable"
require "rspec_magic/unstable"

# TODO: Здесь `config.spec_path`.
```

> 💡 *Работает всё, просто то, что в наборе `unstable`, появилось недавно,*
> *и может измениться в ближайших версиях.*
> 👉Или просто объяснить — `unstable` это то, что появилось недавно и ещё может меняться, то, сё.

Можно включить только конкретные фичи:

👉TODO — require конкретно.

## 🟠Фичи

### `alias_method`

👉Это такая-то хрень.

### `context_when`

Создаём стереотипный контекст, задающий внутри себя одну или несколько `let`-переменных.
Блоки ниже взаимозаменяемы.

```ruby
context_when name: "Joe", age: 25 do
  it do
    expect([name, age]).to eq ["Joe", 25]
  end
end
```

```ruby
context "when { name: \"Joe\", age: 25 }" do
  let(:name) { "Joe" }
  let(:age) { 25 }
  it do
    expect([name, age]).to eq ["Joe", 25]
  end
end
```

### `described_sym`

Transform <tt>described_class</tt> into an underscored symbol.

```ruby
describe UserProfile do
    it { expect(described_sym).to eq :user_profile }
    it { expect(me).to eq :user_profile }
end
```

With a factory:

```ruby
describe UserProfile do
    let(:obj1) { create described_sym }
    let(:obj2) { create me }
    …
end
```

### `include_dir_context`

👉Украл тезисы с Гитхупа, этой штуке тыща лет.

Include hierarchical contexts from <tt>spec/</tt> up to spec root.

```ruby
describe Something do
  include_dir_context __dir__
  …
end
```

### `use_letset`

Создаём на уровне `describe` метод для задания `let`-переменных, автоматически составляющих коллекцию типа `Hash`.

```ruby
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
```

### `use_method_discovery`

Создаём автоматическую `let`-переменную, содержащую название метода или action,
вычисленное из текста вышестоящего `describe`.

```ruby
describe do
  use_method_discovery :m

  subject { m }

  describe "#first_name" do
    # TODO: Поддерживается разумная вложенность.
    it { is_expected.to eq :first_name }
  end

  describe ".some_stuff" do
    it { is_expected.to eq :some_stuff }
  end

  describe "GET some_action" do
    it { is_expected.to eq :some_action }
  end
end
```

Бла-бла, «срабатывает» тот describe, у которого текст отформатирован и опознан.
Опознашка — это метод такой-то.
👉Пример, детали.

## Copyright

Продукт распространяется свободно на условиях лицензии MIT.

— © 2018-2024 Алексей Фортуна
