require "./spec_helper"
include Praetorian

describe Praetorian do
  describe ".authorize" do
    it "uses that class's default policy class and authorizes based on it" do
      user = User.new
      post = Post.new(user)
      Praetorian.authorize(user, post, :index?).should eq(post)
      expect_raises(Praetorian::NotAuthorizedException) do
        Praetorian.authorize(user, post, :create?)
      end
    end

    it "can be given a different policy class" do
      user = User.new
      post = Post.new(user)
      Praetorian.authorize(user, post, :create?, PublicationPolicy).should eq(post)
    end

    it "can use a self-defined query method" do
      user = User.new
      post = Post.new(user)
      Praetorian.authorize(user, post, :postable?).should eq(post)
    end

    it "will use an implicit Policy class if not defined in the class" do
      user = User.new
      comment = Comment.new(user)
      Praetorian.authorize(user, comment, :destroy?).should eq(comment)
    end

    it "can be called without the shard name prefix" do
      user = User.new
      post = Post.new(user)
      authorize(user, post, :index?).should eq(post)
    end

    it "can be called with British spelling" do
      user = User.new
      post = Post.new(user)
      Praetorian.authorise(user, post, :index?).should eq(post)
    end

    it "can be called with a string as an action" do
      user = User.new
      post = Post.new(user)
      Praetorian.authorize(user, post, "index?").should eq(post)
    end
  end
end
