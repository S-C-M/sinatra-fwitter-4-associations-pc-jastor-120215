# Sinatra Fwitter 4 -  Associations

## Outline
 1. Create a migration to create a users table. The user should have columns for username and email address. 
 2. Create another migration to add a user_id column to the tweets table. 
 3. Create a User model which inherits from ActiveRecord::Base and `has_many` tweets. 
 4. Update the Tweet model so that it `belongs_to` a User.
 5. Run the pending migrations. Use `tux` to delete all Tweets from the database. 
 6. Update the application controller so that you're finding a user by their username, then associating the newly created Tweet with that user. 
 7. Update the index page so that you're displaying the tweet's user's username, not the tweet's username (tweet no longer responds to a method called username)

## Objectives

1. Understand how different models relate to each other in our Sinatra applicaton
2. Create multiple migrations using rake and ActiveRecord
3. Setup ActiveRecord `has_many` and `belongs_to` relationships. 

## Overview

Every social media application, whether it's Facebook, Twitter, Tumblr, etc. has some concept of you as a user. This is why you can have a bio, friends, posts, photos, etc. Every time you log in, the application loads up your profile and all of your associated information. Today, we'll be adding a User model to our Fwitter application and learn how to use ActiveRecord to associate our tweets with that user.

## Instructions

Fork and clone this repository and run "bundle install" to get started!

### Part 1: Creating a users table

By now, you're probably a pro at creating ActiveRecord migrations. Let's create a new migration that will create a table called `users`.  We could add as many attributes as we want - `username`, `fullname`, `bio`, `phone_number`, etc. For now, let's keep it simple with two columns: one for `username`, and one for `email`. 

First, create a new migration with the following rake command: `rake db:create_migration NAME="create_users"`

Inside of our create_users file, let's create methods for `up` and `down`.

```ruby
class CreateUsers < ActiveRecord::Migration

  def up
    create_table :users do |t|
      t.string :username
      t.string :email
    end
  end
  
  def down
    drop_table :users
  end

end
```
This will create a table called users with two columns. Awesome job! Now that our table has been created, let's make a cooresponding model. In your models directory, create a file called `user.rb` and add the following code:

```ruby
class User < ActiveRecord::Base

end
```
Now, our application will have access to a class of `User`. Instances of this class will respond to two methods: `username` and `email`. Be sure to require this new file in your `application_controller` as well. Awesome job!

### Part 2: Updating our tweets table

If we were to describe the relationship between a User and a Tweet, we might say that a User has many Tweets and that a Tweet belongs to a User. Let's update our application to make this relationship possible. It is our Tweet's responsibility to keep track of who it's user is - ActiveRecord let's us do this using a column called `user_id`. This convention is very important - because a tweet belongs to a user, the column must be called `user_id`. We'll use this to reference our users in the user table. 

How can we update our schema? With another migration file! Let's create a migration called `modify_tweets`. `rake db:create_migration NAME="modify_tweets"` and create methods for `up` and `down`. For our `up` method, we'll use ActiveRecord's `add_column` method to add a column called `user_id`. The syntax for this is `add_column :table_name, :column_name, :data_type`. For our user_id column, add the code below:

```ruby
class ModifyTweets < ActiveRecord::Migration
  
  def up
    add_column :tweets, :user_id, :integer
  end
  
  def down
  
  end
  
end

```

Our up method should also remove the `username` from tweets. We'll use ActiveRecord's `remove_column` method. 

```ruby
class ModifyTweets < ActiveRecord::Migration
  
  def up
    add_column :tweets, :user_id, :integer
    remove_column, :tweets, :username
  end
  
  def down
    
  end
  
end

```

Our down method will be run only if we need to revert our changes and should be the opposite of our up method.

```ruby
class ModifyTweets < ActiveRecord::Migration
  
  def up
    add_column :tweets, :user_id, :integer
    remove_column, :tweets, :username
  end
  
  def down
    remove_column :tweets, :user_id
    add_column :tweets, :username, :string
  end
  
end

```

Awesome job! Go ahead and run these migrations using `rake db:migrate`!

### Part 3: Updating our Models

Remember how we described the relationship between a user and tweets? We said that a user "has many" tweets and that a tweet "belongs to" a user. ActiveRecord let's us conclude this relationship with two lines of code. In your User model, add a line stating that a user `has_many :tweets`. Update your Tweet model with a line that it `belongs_to : user`. 

```ruby

class User < ActiveRecord::Base
  has_many :tweets
end
```

```ruby

class Tweet < ActiveRecord::Base
  belongs_to :user
end
```

This just extened our models with new methods. The main ones: our User model now responds to a method called `.tweets`. This will return an array of each tweet instance from our database. Our Tweet class also responds to a method called `user` which returns the user object the tweet is associated with. This relationship works because our `tweets` table has a column called `user_id`. 

Let's test this out. Boot up `tux` in your console. First, let's destroy all of the Tweets from our database that were created before we had a User model.

```ruby
>> Tweet.destroy_all
```

Next, let's create a new instance of our User class.

```ruby
>> user = User.new(:username => "taylorswift13", :email => "taylor@taylorswift.com")
>> user.save
=> #<ActiveRecord::Relation [#<User id: 1, username: "taylorswift13", email: "taylor@taylorswift.com">]>
```

Awesome - now, let's create a Tweet that will be associated with this user. Instead of passing in the username as an attribute, we'll pass in the user object. 

```ruby
>> tweet = Tweet.new(:status => "First tweet with a user object!!", :user => user)
>> tweet.save
=> #<Tweet id: 1, status: "First tweet with a user object", user_id: 1>
```

Awesome job, we've got a tweet in our database that's associated with a user! Let's test this out:

```ruby
>> user.tweets
D, [2015-09-14T10:18:48.152353 #8945] DEBUG -- :   Tweet Load (0.2ms)  SELECT "tweets".* FROM "tweets" WHERE "tweets"."user_id" = ?  [["user_id", 3]]
=> #<ActiveRecord::Associations::CollectionProxy [#<Tweet id: 1, status: "First tweet with a user object", user_id: 1>]>

>> tweet.user
D, [2015-09-14T10:19:51.362410 #8945] DEBUG -- :   User Load (0.3ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
=> #<User id: 1, username: "taylorswift13", email: "taylor@taylorswift.com">
```
We can see the SQL that gets fired when we run these methods - ActiveRecord runs queries based on the :user_id associated with the tweets column. Awesome. Let's implement this new functionality into our application. 

### Part 4: Updating our Views and Controller

First, if we try to run our application right now, we'll get an error "undefined method 'username' for 'tweet'" This is because our tweets don't respond to a method called username anymore, they respond to a method called "user". Let's update our index page to fix this. 

```erb
<h1>Welcome to Fwitter!</h1>

<h2>Tweets!</h2>
<% @tweets.each do |tweet| %>
	<p><strong><%= tweet.username %>:</strong> <%= tweet.status %></p>
<% end %>
```
First, we'll change this to `tweet.user` to get the user object.

```erb
<h1>Welcome to Fwitter!</h1>

<h2>Tweets!</h2>
<% @tweets.each do |tweet| %>
	<p><strong><%= tweet.user %>:</strong> <%= tweet.status %></p>
<% end %>
```

This user object will now respond to a method called username - we can chain this together to get the actual username out of the user object.

```erb
<h1>Welcome to Fwitter!</h1>

<h2>Tweets!</h2>
<% @tweets.each do |tweet| %>
	<p><strong><%= tweet.user.username %>:</strong> <%= tweet.status %></p>
<% end %>
```

Awesome. Next, let's update how our tweets get created in our application controller. First, we'll find the user object by the username they enter. Next, we'll pass that user to the tweet upon creation. 

```ruby
post '/tweet' do
  user = User.find_by(:username => params[:username])
  tweet = Tweet.new({:user => user, :status => params[:status]}) 
  tweet.save 
  redirect '/'
end
```

Now, our tweet will be associated with the user when the form is submitted. Awesome! 