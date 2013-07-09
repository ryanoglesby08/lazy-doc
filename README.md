# LazyDoc

NOTE: LazyDoc is currently in alpha and is not quite ready for use.

An implementation of the [Embedded Document](http://martinfowler.com/bliki/EmbeddedDocument.html) pattern for POROs.
The embedded JSON is lazily parsed so that needed attributes from the document are only parsed when accessed.
Finally, parsed values are cached so that subsequent access does not reach into the JSON again.

Add this line to your application's Gemfile:

    gem 'lazy_doc'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lazy_doc

## Usage

```ruby
class User
    include LazyDoc::DSL

    find :name                              # Access the attribute "name"
    find :address, by: :street_address      # Access the attribute "street_address"
    find :job, by: [:profile, :occupation, :title]      # Access the attribute "title" found at "profile" -> "occupation"

    def initialize(json)
      init(json)                            # Initialize the LazyDoc object
    end
end

user = User.new(json)
puts user.name
puts user.address
puts user.job
```

## To Do
1. DONE - Full path parsing more than just top level.  ex: `find :name, by: [:profile, :basic_info, :name]`
2. Error handling for incorrectly specified paths
3. Exception handling when a json does not contain a path, but that is ok.
4. Transforms.
    - Ruby provided. ex: `find :name, then: :capitalize`
    - User defined.  ex: `find :name, then: lambda { |name| name.gsub('-',' ') }`
5. Objects from sub-trees.  ex: `find :profile, as: Profile` (This would construct a LazyDoc Profile object and pass the json found at "profile" to it)
6. Collections.
    - Map. For example, extract array of customer names from array of customers. ex: `find :customers, extract: :name`
    - Objects from collection. Instead of extracting just the name, extract whole objects like in #5.  ex:  `find :customers, as: Customer`
7. Joins
    - Using previously defined attributes. ex: `join :address, from: [:street, :city, :state:, :zip]`
    - Defining attributes in place.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
