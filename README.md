# LazyDoc

[![Build Status](https://travis-ci.org/ryanoglesby08/lazy-doc.png)](https://travis-ci.org/ryanoglesby08/lazy-doc)



An implementation of the [Embedded Document](http://martinfowler.com/bliki/EmbeddedDocument.html) pattern for POROs.

LazyDoc provides a declarative DSL for extracting deeply nested values from a JSON document. The embedded JSON is lazily
parsed so that needed attributes from the document are only parsed when accessed. Finally, parsed values are cached
so that subsequent access does not access the JSON again.

*Currently, LazyDoc only supports JSON. XML support may be added later.*

## Installation

Add this line to your application's Gemfile:

    gem 'lazy_doc'

## DSL Options

1. Basic usage. `access`: `access :name` will look for a property called 'name' at the top level of the embedded document.
2. `access :name, :phone, :address` will look for all three properties. *This option does not currently support using any options.*
3. `via`: `access :job, via: [:profile, :occupation]` will look for a property called 'job' by parsing through
'profile' -> 'occupation'.
4. `default`: `access :currency, default: 'USD'` will use the default value of 'USD' if the currency attribute is set to an empty value (`empty?` or `nil?`)
5. `finally`: `access :initials, finally: lambda { |initials| initials.upcase }` will call the supplied block, passing in
'initials,' and will return the result of that block.
6. `as`: `access :profile, as: Profile` will pass the sub-document found at 'profile' into a new 'Profile' object, and will return
the newly constructed Profile object. This is great for constructing nested LazyDoc relationships.
7. `extract`: `access :customers, extract: :name` will make the assumption that the attribute 'customers' will be an array of objects and will extract the 'name' property from each object and return an array of 'names' (This would be the equivalent of the Enumerable#map method)



## Example Usage

```ruby
class User
    include LazyDoc::DSL

    access :name                                        # Access the attribute "name"
    access :address, via: :streetAddress                # Access the attribute "streetAddress"
    access :job, via: [:profile, :occupation, :title]   # Access the attribute "title" found at "profile" -> "occupation"

    def initialize(json)
      lazily_embed(json)                                # Initialize the LazyDoc object
    end
end

json = '{"name": "George Washington", "streetAddress": "The White House", "profile": {"occupation": {"title": "President"}}}'
user = User.new(json)
puts user.name
puts user.address
puts user.job
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
