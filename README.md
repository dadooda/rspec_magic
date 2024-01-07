
# A little bit of magic for RSpec tests

<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Overview](#overview)
- [Setup](#setup)
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
The path computed should point to `spec/` of the project's directory.

See [Details](#on-setup).

💧💧💧 ALL ABOVE THIS LINE IS CLEAR 💧💧💧

Настройка `spec_path=` нужна для некоторых фич, например, [include_dir_context](#include_dir_context).
Вычисленный путь должен указывать на `spec/` в директории проекта.

См. [Подробно](#про-установку).

## Details

### On setup

Tralala
