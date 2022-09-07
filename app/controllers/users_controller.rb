class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]
  before_action :ensure_guest_user, only: [:edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books.includes(:favorites).sort {|a,b| b.favorites.size <=> a.favorites.size}
    @book = Book.new
    @following_users = @user.following_user
    @follower_users = @user.follower_user
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  def follows
    @user = User.find(params[:id])
    @users = @user.following_user.all
    @following_users = @user.following_user
    @follower_users = @user.follower_user
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.follower_user.all
    @following_users = @user.following_user
    @follower_users = @user.follower_user
  end

  private
    def user_params
      params.require(:user).permit(:name, :introduction, :profile_image)
    end

    def ensure_correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        redirect_to user_path(current_user)
      end
    end

    def ensure_guest_user
      @user = User.find(params[:id])
      if @user.name == "guestuser"
        redirect_to user_path(current_user), notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
      end
    end
end
