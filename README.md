# LolConcurrency

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'lol_concurrency'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lol_concurrency

## Usage

    class Foo
      include LolConcurrency::Future
      include LolConcurrency::Actor

      def long_running_method
        # Implementation
      end

      def background_job
        # Implementation
      end
    end

    foo = Foo.new
    foo.async.background_job
    future = foo.future.long_running_method
    # ...
    value = future.value

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
