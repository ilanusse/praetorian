module Praetorian
  #
  # A Policy is a collection of methods that responds to authorization queries. The ones listed below
  # are defaults and should be overwritten when writing Policy classes.
  #
  module Policy
    def index?
      false
    end

    def show?
      false
    end

    def create?
      false
    end

    def new?
      create?
    end

    def update?
      false
    end

    def edit?
      update?
    end

    def destroy?
      false
    end
  end
end
