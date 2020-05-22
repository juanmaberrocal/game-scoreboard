# frozen_string_literal: true

class Ability
  include CanCan::Ability

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def initialize(user)
    return unless user.present?

    can :read, Game
    can :statistics, Game
    can :standings, Game

    can :read, Match
    can :create, Match

    can :confirm, MatchPlayer, player_id: user.id
    can :reject, MatchPlayer, player_id: user.id

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
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
