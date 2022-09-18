# Variables

Mina variables are like Ruby variables: they have a name (also called a key) and a value. Mina variables, however, differ in the fact that they're global and can be accessed from anywhere in the `deploy.rb` just by knowing its key.

Variables are the primary way of configuring parameters necessary for some tasks. For example, Mina needs to know the domain it's SSH-ing to. It knows this by fetching the variable with the key `:domain`, which you'll have to set in your `deploy.rb`.

Note: the example above used a symbol (`:domain`) as variable key. Even though variable keys can technically be of any type (string, integer, etc.), we recommend you use symbols.

## DSL

Mina provides a couple of methods for managing variables. The following sections document them.

### `set(key, value)`

Sets a variable.

A value can either be a literal or a callable (something that responds to `#call`, e.g. a proc or a lambda). In case of a callable, the value will be resolved when the variable is read.

`set` can be called multiple times for the same key, it just overwrites the old value.

Example:
```ruby
set :domain, 'foo.com' # literal
set :domain, 'bar.com'

puts fetch(:domain)
# => 'bar.com'

set :path, -> { "#{fetch(:domain)}/baz" } # callable

puts fetch(:path)
# => 'bar.com/baz'
```

### `fetch(key, default = nil)`

Returns the variable value.

If the key doesn't exist, the default value is returned, which, by default, is `nil`. You can override the default value by providing a second parameter to the method.

Environment variables with the same name override values configured with `set`. (Note: this behavior is deprecated, it will be removed in v2)

Example:
```ruby
set :domain, 'foo.com'

puts fetch(:domain)
# => 'foo.com'

puts fetch(:missing_key)
# => nil

puts fetch(:missing_key, 'default')
# => 'default'

ENV['branch'] = 'foo' # mimic environment variable 'branch=foo'

puts fetch(:branch)
# => 'foo'
```

### `set?(key)`

Returns whether a value exists for a key.

If the key has been set, but its value is `nil`, the method will return `false`.

The method also checks if there exists an environment variable by the same name. (Note: this behavior is deprecated, it will be removed in v2)

Example:
```ruby
set :domain, 'foo.com'
set :subdomain, nil

puts set?(:domain)
# => true

puts set?(:subdomain)
# => false (variable exists, but its value is nil)

puts set?(:missing_key)
# => false (variable doesn't exist)

ENV['branch'] = 'foo' # mimic environment variable 'branch=foo'

puts set?(:branch)
# => true
```

### `ensure!(key, message: nil)`

Guard method with the purpose of ensuring that a variable exists.

If the value is set (which is checked with the [`set?`](#setkey) method), the program continues normally.

If the value isn't set, the program prints an error message and exits with code 1.

Optionally, a custom error message can be provided as a keyword param.

Why is this useful? As was said in the intro, some tasks require certain variables, like `:domain`. If this variable didn't exist, the task wouldn't work correctly. Therefore, to ensure that a task doesn't execute with a variable missing, which can result in weird bugs, we use `ensure!` to exit before the task is executed, and warn the user that they need to fix something.

Example:
```ruby
set :domain, 'foo.com'
set :subdomain, nil

ensure!(:domain)
# the program continues normally because :domain variable has a value

ensure!(:subdomain)
# the program would exit here and print 'subdomain must be defined'

ensure!(:subdomain, message: 'subdomain is mandatory')
# the program would exit here and print 'subdomain is mandatory'
```
