require "./spec_helper"

describe Praetorian do

  describe ".authorize" do
    it "uses that class's default policy class and authorizes based on it" do
      user = User.new
      post = Post.new(user)
      Praetorian.authorize(user, post, :index?).should be_truthy
      expect_raises(Praetorian::NotAuthorizedException) do
        Praetorian.authorize(user, post, :create?)
      end
    end

    it "can be given a different policy class" do
      user = User.new
      post = Post.new(user)
      Praetorian.authorize(user, post, :create?, PublicationPolicy).should be_truthy
    end

    it "can use a self-defined query method" do
      user = User.new
      post = Post.new(user)
      Praetorian.authorize(user, post, :postable?).should be_truthy
    end

    it "will use an implicit Policy class if not defined in the class" do
      user = User.new
      comment = Comment.new(user)
      Praetorian.authorize(user, comment, :destroy?).should be_truthy
    end
  end
end
