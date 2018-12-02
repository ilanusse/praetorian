require "spec"
require "../src/praetorian"
require "../src/praetorian/has_policy"
require "../src/praetorian/policy"

struct User
end

struct Post
  include Praetorian::HasPolicy

  property user : User

  def initialize(user : User)
    @user = user
  end

  def policy_class
    PostPolicy
  end
end

struct PostPolicy
  include Praetorian::Policy

  property user, post

  def initialize(@user : User, @post : Post)
  end

  def index?
    true
  end

  def postable?
    true
  end
end

struct PublicationPolicy
  include Praetorian::Policy

  property user, post

  def initialize(@user : User, @post : Post)
  end

  def create?
    true
  end
end
