
# Немного магии для RSpec-тестов

<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Что это?](#что-это)
- [Установка](#установка)
- [Фичи](#фичи)
  - [`alias_method`](#alias_method)
  - [`context_when`](#context_when)
  - [`described_sym`](#described_sym)
  - [`include_dir_context`](#include_dir_context)
  - [`use_letset`](#use_letset)
  - [`use_method_discovery`](#use_method_discovery)
- [Подробно](#подробно)
  - [Про установку](#про-установку)
  - [Про `context_when`](#про-context_when)
  - [Про `include_dir_context`](#про-include_dir_context)
- [Copyright](#copyright)

<!-- /code_chunk_output -->

## Что это?

🆎 *An English version of this text is also available: [README.md](README.md).*

RSpecMagic — набор расширений для написания компактных и ёмких тестов.

## Установка

> 💡 *Предполагается, что RSpec в нашем проекте мы уже настроили.*

Добавляем в `Gemfile`:

```ruby
gem "rspec_magic"
#gem "rspec_magic", git: "https://github.com/dadooda/rspec_magic"
```

Добавляем в автозагрузку RSpec (обычно это `spec/spec_helper.rb`):

```ruby
require "rspec_magic/stable"
require "rspec_magic/unstable"

RSpecMagic::Config.spec_path = File.expand_path(".", __dir__)
```

Настройка `spec_path=` нужна для некоторых фич, например, [include_dir_context](#include_dir_context).
Вычисленный путь должен указывать на `spec/` в директории проекта.

См. [Подробно](#про-установку).

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

`described_sym` и `me` — представление имени `described_class` в виде `Symbol`.
Помогает не «долдонить» мнемоническим названием тестируемого класса, например,
при создании записей с помощью factory.

```ruby
describe UserProfile do
  it { expect(described_sym).to eq :user_profile }
  it { expect(me).to eq :user_profile }
end
```

С factory:

```ruby
describe UserProfile do
  let(:uprof1) { create described_sym }
  let(:uprof2) { create me }
  …
end
```

### `include_dir_context`

♒︎ *Эта фича добавлена недавно и может измениться.*

Организуем общие контексты (`shared_context`) в иерархии.
Автоматически включаем иерархию нужных общих контекстов в наш тест.

Шаги:

1. Убеждаемся, что в настройках правильно прописан `RSpecMagic::Config.spec_path`.
   Он должен указывать на `spec/`.

2. По файловому дереву тестов создаём файлы общих контекстов *с одинаковым именем,* например, `_context.rb`.
   Содержимое `_context.rb` всегда имеет вид:

   ```ruby
   shared_context __dir__ do
     …
   end
   ```

3. Добавляем в условный `spec_helper.rb`:

   ```ruby
   # Загружаем иерархию shared contexts.
   Dir[File.expand_path("**/_context.rb", __dir__)].each { |fn| require fn }
   ```

4. В spec-файле добавляем вызов `include_dir_context` в тело главного `describe`:

   ```ruby
   describe … do
     include_dir_context __dir__
     …
   end
   ```

Например, наш spec-файл это `spec/app/controllers/api/player_controller_spec.rb`.

В главный `describe` будут последовательно загружены, *если они есть,* контексты из файлов:

```
spec/_context.rb
spec/app/_context.rb
spec/app/controllers/_context.rb
spec/app/controllers/api/_context.rb
```

См. [Подробно](#про-include_dir_context).

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

Если передан блок, `let_a` работает как обычный `let`. Такой вариант изредка тоже бывает полезен:

```ruby
describe do
  use_letset :let_a, :attrs

  let_a(:age) { 25 }
  let_a(:name) { "Joe" }

  it { expect(attrs).to eq(name: "Joe", age: 25) }
end
```

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
    describe "intermediate context" do
      it { is_expected.to eq :some_action }   # (1)
    end
  end
end
```

`m` находит ближайший контекст, формат текста которого допускает выемку имени метода.
См. (1) — `m` пропустила вольно отформатированный `"intermediate context"` и сработала
на `"GET some_action"`.

## Подробно

### Про установку

1. `stable` и `unstable` — наборы фич. В набор `unstable` входят фичи,
   добавленные недавно. Они могут измениться в следующих версиях.

2. Можно включить только конкретные фичи. Например:

   ```ruby
   require "rspec_magic/stable/use_method_discovery"
   ```

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

4. Значения `let`-переменных вычисляются на уровне `describe`. Если нужны значения, вычисляемые на уровне `it`, следует использовать обычный `let(…) { … }` внутри контекста.

### Про `include_dir_context`

Есть в RSpec классная штука — общие контексты, они же [shared_context](https://rspec.info/features/3-12/rspec-core/example-groups/shared-context/).
Замысел простой: где-то (в условном `spec_helper.rb`) мы создаём нечто общее через `shared_context "то сё"`,
а потом через `include_context "то сё"` импортируем материал в нужный там тест.

Наполнять `shared_context` можно чем угодно — общими тестами, `before`-блоками, `let`-переменными, *но главное* — 
методами уровня `describe` (`def self.doit`) и методами уровня `it` (`def doit`).

Чем не библиотека?

Казалось бы — вот оно счастьюшко, сочиняй свои расширения, разноси по общим контекстам, где надо импортируй и радуйся.
Но есть неприятная особенность: штатные средства организации очень примитивны и опираются на глобальные уникальные имена.

RSpec не позволяет организовывать общие контексты в иерархии,
чтобы автоматически импортировать контексты-«библиотеки» в группы spec-файлов, как то:
*всем* тестам моделей — своё, *всем* тестам контроллеров — своё, а *всем* вместе — общеполезное.

Чтобы поддерживать мало-мальский порядок, приходится натужно придумывать общим контекстам
уникальные имена, и *в каждом* spec-файле перечислять импортируемое унылым повторяющимся списком:

```ruby
describe … do
  include_context "basic"
  include_context "controllers"
  include_context "api_controllers"
  …
end
```

И это ещё продвинутый уровень.
Чаще всего даже так не делают, а просто сваливают все расширения в кучу и включают сразу всё,
просто потому, что «некогда разбираться».

Что даёт `include_dir_context`?

1. Возможность организовывать общие контексты в иерархии.
2. Возможность автоматически включать наборы *того, что нужно, туда, куда нужно.*

Как это делать, описано в [основной главе](#include_dir_context).

## Copyright

Продукт распространяется свободно на условиях лицензии MIT.

— © 2017-2024 Алексей Фортуна
