# Praetorian
[![Build Status](https://travis-ci.org/ilanusse/praetorian.svg?branch=master)](https://travis-ci.org/ilanusse/praetorian)

A minimalist Crystal authorization system inspired by https://github.com/varvet/pundit.

## Installation

```crystal
dependencies:
  praetorian:
    github: ilanusse/praetorian
```

## Policies

Praetorian, inspired by Pundit, works with policy classes. This shard is not designed to be extra compatible with any framework but rather with flexibility in mind.
This is a simple example that allows updating
a post if the user is an admin, or if the post is unpublished:

```crystal
class Post
  def policy_class
    PostPolicy
  end
end


class PostPolicy
  include Praetorian::Policy

  property user, post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def update?
    user.admin? || !post.published?
  end
end
```

There are two things to notice here:
- The Post is a class that should obey a certain Policy. We can either write a `policy_class` method to return the policy class name, or Praetorian will assume the policy classname to be `#{model_name}Policy`.

- The Policy class includes `Praetorian::Policy`. This adds default query methods to our policy as defaults that should be overwritten as necessary.

The default query methods defined in `Praetorian::Policy` are: `index?`, `show?`, `create?`, `new?`, `update?`, `edit?`, `destroy?`.

Ok. So far, pretty simple.

You can set up simple base classes to inherit from:

```crystal
class ApplicationModel < WhateverORMYouAreUsingModel
  include Praetorian::HasPolicy # So you just need to overwrite `policy_class` in each model
end

class ApplicationPolicy
  include Praetorian::Policy

  property user, record

  def initialize(user, record)
    @user = user
    @record = record
  end
end
```

Supposing that you have an instance of class `Post`, Praetorian lets you authorize the object use in
your code flow:

```crystal
def update
  @post = Post.find(params[:id])
  Praetorian.authorize(current_user, @post, :update?)
  # Rest of code flow
end
```

A `Praetorian::NotAuthorizedException` will be raised if the user is not authorized to perform said query on the record.

You can pass an argument to override the policy class if necessary. For example:

```crystal
def create
  @publication = find_publication # assume this method returns any model that behaves like a publication
  # @publication.class => Post
  Praetorian.authorize(current_user, @publication, :create?, PublicationPolicy)
  # Rest of code flow
end
```

# License

Licensed under the MIT license, see the separate LICENSE.txt file.
