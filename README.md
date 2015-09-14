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


### Part 1: Do Some Stuff

## Resources

* [Stack Exchange](http://www.stackexchange.com) - [Some Question on Stack Exchange](http://www.stackexchange.com/questions/123)