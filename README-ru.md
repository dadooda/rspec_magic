
# Немного магии для RSpec-тестов

<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Что это?](#что-это)
- [Установка](#установка)
- [Применение](#применение)
- [Фичи](#фичи)
  - [`alias_method`](#alias_method)
  - [`context_when`](#context_when)
  - [`described_sym`](#described_sym)
  - [`include_dir_context`](#include_dir_context)
  - [`use_letset`](#use_letset)
  - [`use_method_discovery`](#use_method_discovery)
- [Подробно](#подробно)
  - [Про «Применение»](#про-применение)
  - [Про `context_when`](#про-context_when)
- [Copyright](#copyright)

<!-- /code_chunk_output -->

## Что это?

🆎 *An English version of this text is also available: [README.md](README.md).*

RSpecMagic — набор расширений для написания компактных и ёмких RSpec-тестов.

## Установка

> 💡 *Предполагается, что RSpec в нашем проекте мы уже настроили.*

Добавляем в `Gemfile`:

```ruby
gem "rspec_magic"
#gem "rspec_magic", git: "https://github.com/dadooda/rspec_magic"
```

## Применение

Добавляем в автозагрузку RSpec (обычно это `spec/spec_helper.rb`):

```ruby
require "rspec_magic/stable"
require "rspec_magic/unstable"

RSpecMagic::Config.spec_path = File.expand_path(__dir__)
```

См. [Подробно](#про-применение).

## Фичи

### `alias_method`

Matcher, сверяющий, что метод является alias'ом другого метода.

```ruby
describe User do
  it { is_expected.to alias_method(:admin?, :is_admin) }
end
```

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

См. [Подробно](#про-context_when).

### `described_sym`

`described_sym` и `me` — представление имени `described_class` в виде `Symbol`. Нужно для того, чтобы не «долдонить» мнемоническим названием описываемого класса, например, снова и снова создавая записи с помощью factories.

```ruby
describe UserProfile do
  it { expect(described_sym).to eq :user_profile }
  it { expect(me).to eq :user_profile }
end
```

С factories:

```ruby
describe UserProfile do
  let(:uprof1) { create described_sym }
  let(:uprof2) { create me }
  …
end
```

💧💧💧 ВЫШЕ ВСЁ ЧИСТО! 💧💧💧

### `include_dir_context`

♒︎ *Эта фича добавлена недавно и может измениться.*

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

Бла-бла, `let_a` может работать и как обычный `let`:

```ruby
let_a(:name) { "Joe" }
let_a(:age) { 25 }
```

Такой вариант применения более редок, но иногда тоже бывает полезен.

### `use_method_discovery`

Создаём автоматическую `let`-переменную, содержащую имя метода или action,
вычисленное из текста вышестоящего `describe`.

```ruby
describe do
  use_method_discovery :m

  subject { m }

  describe "#first_name" do
    it { is_expected.to eq :first_name }
  end

  describe ".some_stuff" do
    it { is_expected.to eq :some_stuff }
  end

  describe "GET some_action" do
    # TODO: Поддерживается разумная вложенность.
    it { is_expected.to eq :some_action }
  end
end
```

Бла-бла, «срабатывает» тот describe, у которого текст отформатирован и опознан.
Опознашка — это метод такой-то.
В примере выше — это `"GET some_action"`.
👉Пример, детали.

## Подробно

### Про «Применение»

1. `stable` и `unstable` — наборы фич. В набор `unstable` входят фичи,
   добавленные недавно. Они могут измениться в следующих версиях.

2. Можно включить только конкретные фичи. Например:

   ```ruby
   require "rspec_magic/stable/use_method_discovery"
   ```

3. Настройка `spec_path=` нужна для некоторых фич, например, [include_dir_context](#include_dir_context).
   Вычисленный путь должен соответствовать `spec/` в директории проекта.

### Про `context_when`

1. Контекст можно исключить из обработки, приписав к началу `x`:

   ```ruby
   xcontext_when … do
     …
   end
   ```

2. Можно определить свой метод для форматирования строки для отчёта:

   ```ruby
   context "…" do
     def self._context_when_formatter(h)
       "when #{h.to_json}"
     end

     context_when … do
       …
     end
   end
   ```

3. `context_when` эффективно работает в паре с [use_letset](#use_letset), обычно для задания атрибутов тестируемого объекта.

4. Значения `let`-переменных вычисляются на уровне `describe`. Если нужны значения, вычисляемые на уровне `it`, следует использовать обычный `let()` внутри контекста.





## Copyright

Продукт распространяется свободно на условиях лицензии MIT.

— © 2018-2024 Алексей Фортуна
