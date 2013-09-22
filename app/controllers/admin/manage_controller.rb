class Admin::ManageController < ApplicationController
  before_filter :authenticate_user!
end