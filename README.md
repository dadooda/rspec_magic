
# A little bit of magic for RSpec tests

<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Overview](#overview)
- [Setup](#setup)
- [Features](#features)
  - [`alias_method`](#alias_method)
  - [`context_when`](#context_when)
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

See [Details](#on-setup).

💧💧💧 ALL ABOVE THIS LINE IS CLEAR 💧💧💧

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
  it does
    expect([name, age]).to eq ["Joe", 25]
  end
end
```

```ruby
context "when { name: \"Joe\", age: 25 }" do
  let(:name) { "Joe" }
  let(:age) { 25 }
  it does
    expect([name, age]).to eq ["Joe", 25]
  end
end
```

See [Details](#about-context_when).

## Details

### On setup

Tralala
