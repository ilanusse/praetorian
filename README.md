# Praetorian
[![Build Status](https://travis-ci.org/ilanusse/praetorian.svg?branch=master)](https://travis-ci.org/ilanusse/praetorian)
[![Version](https://img.shields.io/github/tag/ilanusse/praetorian.svg?maxAge=360)](https://github.com/ilanusse/praetorian/releases/latest)
[![License](https://img.shields.io/github/license/ilanusse/praetorian.svg)](https://github.com/ilanusse/praetorian/blob/master/LICENSE)

Praetorian is a minimalist Crystal authorization system inspired by [Pundit](https://github.com/varvet/pundit). It aims to be both lightweight and dependency-less.

## Installation

```crystal
dependencies:
  praetorian:
    github: ilanusse/praetorian
```

## How to use

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


# Somewhere in your code
def update
  @post = Post.find(params[:id])
  Praetorian.authorize(current_user, @post, :update?) # You can also use .authorise if you're a Brit
  # Rest of code flow
end
```

There are two things to notice here:
- The Post is a class that should obey a certain Policy. We can either write a `policy_class` method to return the policy class name, or Praetorian will assume the policy classname to be `#{variable_name}Policy`.

- The Policy class includes `Praetorian::Policy`. This adds default query methods to our policy as defaults that should be overwritten as necessary.

The default query methods defined in `Praetorian::Policy` are: `index?`, `show?`, `create?`, `new?`, `update?`, `edit?`, `destroy?`.

A `Praetorian::NotAuthorizedException` will be raised if the user is not authorized to perform said query on the record.

Ok. So far, pretty simple.

You can set up a simple base class to inherit from:

```crystal
class ApplicationPolicy
  include Praetorian::Policy

  property user, object

  def initialize(user, object)
    @user = user
    @object = object
  end
end
```

### Including the shard as a module

You can include the shard as a module in your controller base class to avoid the prefix:

```crystal
class ApplicationController
  include Praetorian
end

class PostController < ApplicationController
  @post = Post.find(params[:id])
  authorize(current_user, @post, :update?) # yay no prefix
end
```

### Using a specific policy class
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
