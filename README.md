# delegate_associations

## Usage

```ruby
class Person < ActiveRecord::Base
  has_one :user
  has_many :books
  
  # columns: :name, email, :phone
end

class User < ActiveRecord::Base
  belongs_to :person, autosave: true
  # columns: :login, :password
  
  def person
    super || build_person
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

