
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
  - [`use_letset`](#use_letset)
  - [`use_method_discovery`](#use_method_discovery)
- [Details](#details)
  - [On setup](#on-setup)
  - [On `context_when`](#on-context_when)
  - [On `include_dir_context`](#on-include_dir_context)
- [Copyright](#copyright)

<!-- /code_chunk_output -->

## Overview

🆎 *Этот текст можно прочитать на русском языке: [README-ru.md](README-ru.md).*

RSpecMagic is a set of extensions for writing compact and expressive tests.

## Setup

> 💡 *It's assumed that you've already set up RSpec in your project.*

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

The `spec_path` is used by some of the features, notably, [include_dir_context](#include_dir_context).
The computed path should point to `spec/` of the project's directory.

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

Create a self-descriptive `"when …"` context with one or more `let` variables defined.
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

See [Details](#on-context_when).

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

### `include_dir_context`

♒︎ *This feature was added recently and may change in the coming versions.*

Organize shared contexts ([shared_context](https://rspec.info/features/3-12/rspec-core/example-groups/shared-context/)) in a hierarchy.
Import relevant shared contexts into the given test.

Follow these steps:

1. Make sure that `RSpecMagic::Config.spec_path` is configured correctly.
   It must point to project's `spec/`.

2. Across the spec directory tree, create the shared context files, each named `_context.rb`.
   A typical `_context.rb` looks like this:

    ```ruby
    shared_context __dir__ do
      …
    end
    ```

3. Add to your hypothetical `spec_helper.rb`:

    ```ruby
    # Load the shared contexts hierarchy.
    Dir[File.expand_path("**/_context.rb", __dir__)].each { |fn| require fn }
    ```

4. In the given spec file, add a call to `include_dir_context` in the body of the outermost `describe`:

    ```ruby
    describe … do
      include_dir_context __dir__
      …
    end
    ```

Say, our spec file is `spec/app/controllers/api/player_controller_spec.rb`.

The main `describe` will load the contexts from the following files, if any:

```
spec/_context.rb
spec/app/_context.rb
spec/app/controllers/_context.rb
spec/app/controllers/api/_context.rb
```

See [Details](#on-include_dir_context).

### `use_letset`

Define a method to create `let` variables, which comprise a `Hash` collection.

```ruby
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
```

When used with a block, `let_a` behaves like a regular `let`:

```ruby
describe do
  use_letset :let_a, :attrs

  let_a(:age) { 25 }
  let_a(:name) { "Joe" }

  it { expect(attrs).to eq(name: "Joe", age: 25) }
end
```

### `use_method_discovery`

Create an automatic `let` variable containing the method or action name,
computed from the description of the parent `describe`.

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

`m` finds the nearest *usable* context, whose description format allows
the extraction of the method name.
At the line marked (1) above, `m` ignores the loosely formatted `"intermediate context"`
and grabs the data from `"GET some_action"`.

## Details

### On setup

1. `stable` and `unstable` are feature sets.
   Set `unstable` contains recently added features that may change in the coming versions.

2. It's possible to include specific features only. Example:

    ```ruby
    require "rspec_magic/stable/use_method_discovery"
    ```

### On `context_when`

1. The context can be temporarily excluded by prepending `x`:

    ```ruby
    xcontext_when … do
      …
    end
    ```

2. It's possible to define a custom report line formatter:

    ```ruby
    describe "…" do
      def self._context_when_formatter(h)
        "when #{h.to_json}"
      end
 
      context_when … do
        …
      end
    end
    ```

3. `context_when` works nicely with [use_letset](#use_letset),
   usually to set the attributes of the object being tested.

4. The values of `let` belong to the `describe` level.
   If you need values computed at the `it` level, use the traditional `let(…) { … }`
   inside the context.

### On `include_dir_context`

There's a cool thing in RSpec — [shared_context](https://rspec.info/features/3-12/rspec-core/example-groups/shared-context/).
The idea is simple: somewhere (in a hypothetical `spec_helper.rb`) fold something reusable in a `shared_context "this and that"`,
and then import that stuff via `include_context "this and that"` where we need it.

We can put anything in `shared_context` — reusable tests, `let` variables, *but most importantly* —
methods, both belonging to the `describe` level (`def self.doit`) and the `it` level (`def doit`).

Sounds like a library, innit?

There's a pinch of salt though.
Existing means of contexts management are very primitive and rely solely on unique global names.

RSpec doesn't let us organize shared contexts in a hierarchy,
and import them automatically into groups of spec files, such as:
*all* model tests get context M, *all* controller tests get context C, and *all* at once get context A.

In order to maintain minimal order, one has to come up with unique names for shared contexts,
and list those contexts *in each and every* spec file:

```ruby
describe … do
  include_context "basic"
  include_context "controllers"
  include_context "api_controllers"
  …
end
```

If you see anything like this, give your kudos to the author, as this is an advanced level.
Most of the time, people don't even do that, but simply dump all of their extensions
into some “helper”-like pile of cr%p, justifying it by stating that “there was no time to sort it out”.

What does `include_dir_context` have to offer?

1. The means to organize shared contexts in a hierarchy.
2. The means to automatically import sets of *what is needed* into *where it's needed.*

See the [main chapter](#include_dir_context) for a step-by-step example.

## Copyright

The product is free software distributed under the terms of the MIT license.

— © 2017-2024 Alex Fortuna
