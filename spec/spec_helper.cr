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

  property user, record

  def initialize(user : User, record : Post)
    @user = user
    @record = record
  end

  def index?
    true
  end
end

struct PublicationPolicy
  include Praetorian::Policy

  property user, record

  def initialize(user : User, record : Post)
    @user = user
    @record = record
  end

  def create?
    true
  end
end
