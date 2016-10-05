# Repres Dosser 领域特定语意表现引擎

[![License](https://img.shields.io/badge/license-MIT-green.svg)](http://opensource.org/licenses/MIT)
[![Gem Version](https://badge.fury.io/rb/repres-dosser.svg)](https://badge.fury.io/rb/repres-dosser)
[![Dependency Status](https://gemnasium.com/badges/github.com/topbitdu/repres-dosser.svg)](https://gemnasium.com/github.com/topbitdu/repres-dosser)

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
  render_ok collection: [ { name: 'Topbit' }, { name: 'Roland' } ]
end
```

The following responding methods are supported:
- 200 render_ok
- 201 render_created
- 202 render_accepted
- 204 render_no_content
- 400 render_bad_request
- 401 render_unauthorized
- 403 render_forbidden
- 404 render_not_found
- 409 render_conflict
- 500 render_internal_server_error

### Pagination

```ruby
include Repres::Dosser::Concerns::ResourcePresentation

paginate total_items: 108, per_page: 10, current_page: 2
# The pagination will be added into the meta of the response body.
```

```javascript
onIndexResourceSuccess: function(data, textStatus, jqXHR)
{
  var pagination = data.meta.pagination;
  console.info('Here are '+pagination.total_items+' items totally.');
  console.info('Ideally '+pagination.per_page+' items on each page.');
  console.info('The current page is '+pagination.current_page+'.');
  // If the required current_page is greater than the total_pages, the current_page is changed to be equal the total_pages.
  // If the required current_page is less than 1, the current_page is changed to 1. The current_page starts from 1.
  console.info('Here are '+pagination.total_pages+' pages totally.');
  console.info('Here are '+pagination.items_on_current_pages+' items on the current page.');
  console.info('The item index is from '+pagination.min_item_on_current_page+' to '+pagination.max_item_on_current_page+' on the current page.');
}
```



## Generators

### Platform generator

```shell
rails generate repres:dosser:platform administration --version 2
```

This will insert the following routings into the config/routes.rb file:
```ruby
scope '/administration-api/v2', module: 'administration/dosser/v2', as: 'administration_dosser_v2' do
  resources :portals, only: :show
end
```

and create the following files:
```shell
app/controllers/administration/dosser/v2/presentation_controller.rb
app/controllers/administration/dosser/v2/portals_controller.rb
```

### Swagger generator

```shell
rails generate repres:dosser:swagger administration --version 2
```

This will call the following command:
```shell
rails generate repres:dosser:platform administration --version 2
```

before insert the swagger_engine & the latest repres-dosser gem into the Gemfile file and will create the following file:
```shell
config/initializers/swagger_engine.rb
lib/swagger/administration_api_v2.json
```
