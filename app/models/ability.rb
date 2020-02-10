class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_ability : user_ability
    else
      guest_ability
    end
  end

  def guest_ability
    can :read, :all
  end

  def admin_ability
    can :manage, :all
  end

  def user_ability
    guest_ability
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user_id: user.id
  end
end
