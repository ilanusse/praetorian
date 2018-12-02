require "./praetorian/version"

module Praetorian
  #
  # Exception that will be raised when authorization has failed.
  #
  class NotAuthorizedException < Exception
    def initialize(query, object, policy)
      super("Not allowed to #{query} this #{object.to_s} using #{policy}")
    end
  end

  #
  # Retrieves the policy for the given object, initializing it with the
  # object and user and finally throwing an error if the user is not
  # authorized to perform the given action.
  #
  macro authorize(user, object, query, policy_class)
    policy = {{policy_class}}.new({{user}}, {{object}})

    Praetorian.check_auth({{query}}, {{object}}, policy)
  end

  macro authorize(user, object, query)
    single_object = {{object}}.is_a?(Array) ? {{object}}.last : {{object}}
    policy = if single_object.responds_to?(:policy_class)
      # Use the defined policy class
      single_object.policy_class.new({{user}}, single_object)
    else
      # Try and use an implicit Policy class. e.g. Post -> PostPolicy
      {{object.stringify.camelcase.id }}Policy.new({{user}}, single_object)
    end

    Praetorian.check_auth({{query}}, {{object}}, policy)
  end

  macro check_auth(query, object, policy)
    raise {{NotAuthorizedException}}.new({{query}}, {{object}}, policy) unless policy.{{query.id}}
    {{object}}
  end
end
