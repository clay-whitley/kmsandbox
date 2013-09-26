class PagesController < ApplicationController
  def home
    KM.record('Viewed Landing Page')
  end
end