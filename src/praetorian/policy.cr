module Praetorian
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
