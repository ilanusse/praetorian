require "./praetorian/version"

module Praetorian
  #
  # Exception that will be raised when authorization has failed.
  #
  class NotAuthorizedException < Exception
    def initialize(query, record, policy)
      super("Not allowed to #{query} this #{record.to_s} using #{policy}")
    end
  end

  #
  # Exception that will be raised when a query that is not supported is called.
  #
  class QueryNotSupportedException < Exception
    def initialize(query)
      super("#{query} is not a supported query in Praetorian")
    end
  end

  #
  # Retrieves the policy for the given record, initializing it with the
  # record and user and finally throwing an error if the user is not
  # authorized to perform the given action.
  #
  def self.authorize(user, record : Praetorian::HasPolicy, query, policy_class = nil)
    policy = policy_class ? policy_class.new(user, record) : self.policy_from_record(user, record)

    raise NotAuthorizedException.new(query, record, policy) unless check_auth(policy, query)

    record
  end

  #
  # Retrieves a policy from an object that should be a record or an ordered collection of records.
  #
  private def self.policy_from_record(user, record)
    single_record = record.is_a?(Array) ? record.last : record
    single_record.policy_class.new(user, single_record)
  end

  #
  # Case statement that calls the query method on the policy object.
  #
  private def self.check_auth(policy, query)
    case query
    when :index?
      policy.index?
    when :show?
      policy.show?
    when :create?
      policy.create?
    when :new?
      policy.new?
    when :update?
      policy.update?
    when :edit?
      policy.edit?
    when :destroy?
      policy.destroy?
    else
      raise QueryNotSupportedException.new(query)
    end
  end
end
