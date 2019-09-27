# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can :read, Game
    can :standings, Player

    can :read, Match
    can :create, Match

    can :read, Player
    can :update, Player, id: user.id
    can :standings, Player

    if user.admin?
      can :manage, Game
      can :manage, Match
      can :manage, Player
    end
  end
end
