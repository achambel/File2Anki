class ResumeController < ApplicationController
  def index
    @resume = Resume.all
  end
end
