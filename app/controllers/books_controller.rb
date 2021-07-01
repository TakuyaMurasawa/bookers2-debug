class BooksController < ApplicationController
before_action :authenticate_user!, only: [:edit, :index, :show]

before_action :correct_post,only: [:edit]

def authenticate_user!
       unless user_signed_in?
        redirect_to new_user_session_path
       end
end

def correct_post
        @book = Book.find(params[:id])
    unless @book.user.id == current_user.id
      redirect_to books_path
    end
end

  def show
    @book = Book.find(params[:id])
    @new_book = Book.new
  end

  def index
    @books = Book.all
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @books = Book.all
      render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
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
    @book.user.id = current_user.id
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
