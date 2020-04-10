# frozen_string_literal: true

class SystemController < ApplicationController
  def ping
    render json: 'pong', status: 200
  end
end
