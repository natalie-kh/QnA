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
    can :read, [Question, Answer, Comment]
  end

  def admin_ability
    can :manage, :all
  end

  def user_ability
    guest_ability
    can :read, Award
    can :create, [Question, Answer, Comment]
    can %i[update destroy], [Question, Answer, Comment], user_id: user.id
    can :accept, Answer, question: { user_id: user.id }
    can :destroy, ActiveStorage::Attachment, record: { user_id: user.id }
    can :vote, [Question, Answer] do |votable|
      !user.author?(votable)
    end
    can :me, User
  end
end
