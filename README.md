
# A little bit of magic for RSpec tests

<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Overview](#overview)
- [Setup](#setup)
- [Features](#features)
  - [`alias_method`](#alias_method)
  - [`context_when`](#context_when)
  - [`described_sym`](#described_sym)
  - [`include_dir_context`](#include_dir_context)
- [Details](#details)
  - [On setup](#on-setup)

<!-- /code_chunk_output -->

## Overview

🆎 *Этот текст можно прочитать на русском языке: [README-ru.md](README-ru.md).*

RSpecMagic is a set of extensions for writing compact and expressive tests.

## Setup

> 💡 *It is assumed that we have already configured RSpec in our project.*

Add to your project's `Gemfile`:

```ruby
gem "rspec_magic"
#gem "rspec_magic", git: "https://github.com/dadooda/rspec_magic"
```

Add to your RSpec startup file (usually `spec/spec_helper.rb`):

```ruby
require "rspec_magic/stable"
require "rspec_magic/unstable"

RSpecMagic::Config.spec_path = File.expand_path(".", __dir__)
```

The `spec_path=` setting is used by some features, notably, [include_dir_context](#include_dir_context).
The computed path should point to `spec/` of the project's directory.

👉Проверил ссылку.

See [Details](#on-setup).

## Features

### `alias_method`

A matcher to check that a method is an alias of another method.

```ruby
describe User do
  it { is_expected.to alias_method(:admin?, :is_admin) }
end
```

### `context_when`

Create a self-descriptive <tt>"when …"</tt> context with one or more `let` variables defined.
The blocks below are synonymous.

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

👉Проверил ссылку.

See [Details](#about-context_when).

### `described_sym`

Transform `described_class` into underscored symbols `described_sym` and `me`.

```ruby
describe UserProfile do
  it { expect(described_sym).to eq :user_profile }
  it { expect(me).to eq :user_profile }
end
```

Common usage with a factory:

```ruby
describe UserProfile do
  let(:uprof1) { create described_sym }
  let(:uprof2) { create me }
  …
end
```

💧💧💧 ALL ABOVE THIS LINE IS CLEAN-1 💧💧💧

### `include_dir_context`

♒︎ *This feature was added recently and may change.*

Organize shared contexts (`shared_context`) in a hierarchy.
Include relevant shared contexts in our test.

Follow these steps:

1. Make sure that `RSpecMagic::Config.spec_path` is configured correctly.
   It must point to project's `spec/`.


🔴🔴🔴STOPPED HERE

2. Based on the test file tree, we create files of common contexts *with the same name,* for example, `_context.rb`.
    The contents of `_context.rb` always look like this:

   ```ruby
   shared_context __dir__ do
     …
   end
   ```

3. Add to the conditional `spec_helper.rb`:

   ```ruby
   # Load the shared contexts hierarchy.
   Dir[File.expand_path("**/_context.rb", __dir__)].each { |fn| require fn }
   ```


4. In the spec file, add the `include_dir_context` call to the body of the main `describe`:

   ```ruby
   describe … do
     include_dir_context __dir__
     …
   end
   ```

For example, our spec file is `spec/app/controllers/api/player_controller_spec.rb`.

*if any* contexts from the files will be sequentially loaded into the main `describe`:

```
spec/_context.rb
spec/app/_context.rb
spec/app/controllers/_context.rb
spec/app/controllers/api/_context.rb
```

See [Details](#about-include_dir_context).

## Details

### On setup

Tralala
