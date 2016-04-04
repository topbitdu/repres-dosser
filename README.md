# Repres Dosser 领域特定语意表现引擎

[![License](https://img.shields.io/badge/license-MIT-green.svg)](http://opensource.org/licenses/MIT)
[![Gem Version](https://badge.fury.io/rb/repres-dosser.svg)](https://badge.fury.io/rb/repres-dosser)

Repres (REsource PRESentation) is a series of resource presentation engines. The Dosser (DOmain-Specific SEmantic Representation) resource presentation engine includes JSON and XML resource presentation templates.
Repres (资源表现)是一系列的资源表现引擎。Dosser (领域特定语意表现) 资源表现引擎包括JSON和XML表现模版。

## Why Use Repres Dosser
Dosser pre-defined some glossaries for RESTful Web API, which follows the Template Method design pattern.
Dosser 预定义了一些适用于 RESTful Web API 的词汇，并且采用了“模版方法”设计模式。

## Recent Update
Check out the [Road Map](ROADMAP.md) to find out what's the next.
Check out the [Change Log](CHANGELOG.md) to find out what's new.

## Usage in Gemfile
```ruby
gem 'repres-dosser'
```

## Include the Concern in Controllers & Respond the Calls
```ruby
include Repres::Dosser::Concerns::ResourcePresentation

def index
  self.criteria = { page: params[:page] }
  render_ok [ { name: 'Topbit' }, { name: 'Roland' } ]
end
```
