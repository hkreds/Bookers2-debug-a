class BooksController < ApplicationController
  def show
    @book = Book.find(params[:id])
    @book_new = Book.new
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.view_counts.create(book_id: @book.id)
    end
    @user = @book.user
    @book_comment = BookComment.new
    @following_users = @user.following_user
    @follower_users = @user.follower_user
  end

  def index
    @books = Book.all.includes(:favorites).sort {|a,b| b.favorites.size <=> a.favorites.size}
    @book = Book.new
    @user = current_user
    @following_users = @user.following_user
    @follower_users = @user.follower_user
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render "index"
    end
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user != current_user
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private
    def book_params
      params.require(:book).permit(:title, :body)
    end
end
