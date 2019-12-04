# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can :read, Game
    can :statistics, Game
    can :standings, Game

    can :read, Match
    can :create, Match

    can :update, MatchPlayer, player_id: user.id

    can :read, Player
    can :update, Player, id: user.id
    can :statistics, Player
    can :standings, Player

    if user.admin?
      can :manage, Game
      can :manage, Match
      can :manage, MatchPlayer
      can :manage, Player
    end
  end
end
