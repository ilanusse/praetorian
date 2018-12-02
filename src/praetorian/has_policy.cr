module Praetorian
  #
  # An interface module that should be included by objects that should respond to a given policy.
  #
  module HasPolicy
    #
    # User implemented. Returns the policy class to be used for the given class.
    #
    abstract def policy_class
  end
end
