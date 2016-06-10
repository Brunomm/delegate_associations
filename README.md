[![Gem Version](https://badge.fury.io/rb/delegate_associations.svg)](https://badge.fury.io/rb/delegate_associations)

# delegate_associations

## Usage

```ruby
class Address < ActiveRecord::Base
  # columns: :city, :district
  
end

class Person < ActiveRecord::Base
  # columns: :name, email, :phone, :address_id
  
  belongs_to :address
  has_one :user
  has_many :books

  def address
    super || build_address # It's very important
  end

  delegate_attributes to: :address, prefix: true  
end

new_person =Person.new(name: "Joe", email: 'joe@mail.com', address_city: 'São Paulo', address_district: 'South Zone')
new_person.name # Joe
new_person.address_city # 'São Paulo'
new_person.address.city # 'São Paulo'
new_person.address_district # 'South Zone'
new_person.address.district # 'South Zone'

class User < ActiveRecord::Base
  belongs_to :person, autosave: true
  # columns: :login, :password
  
  def person
    super || build_person # It's very important
  end
  
  delegate_associations to: :person
  delegate_attributes to: :person
end

new_user =User.new(login: 'admin', password: 'paswd', name: "Joe", email: 'joe@mail.com')
new_user.name # Joe
new_user.login # admin
new_user.user # @user
new_user.books # []

user.email          # 'joe@mail.com'
user.email?         # true
user.email_changed? #true
user.email_was      # nil
```

## Installation

Add this line to your application's Gemfile:

    gem 'delegate_associations'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install delegate_associations

## Credits

* Inspiration for how to do it came from [DelegateAllFor](https://github.com/LessonPlanet/delegate_all_for) and [delegate_attributes](https://rubygems.org/gems/delegate_attributes)

