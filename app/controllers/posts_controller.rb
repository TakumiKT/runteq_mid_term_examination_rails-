class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update]

  def index
    @posts = Post.includes({ user: :profile }, :comments, :tags).distinct
    apply_search_filters
    @posts = @posts.order(created_at: :desc)
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def edit; end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      @post.save_tags
      redirect_to @post, success: '投稿しました'
    else
      render :new
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      @post.save_tags
      redirect_to @post, success: '投稿を更新しました'
    else
      render :edit
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :tag_name)
  end

  def apply_search_filters
    filter_by_post_content
    filter_by_comment_content
    filter_by_username
    filter_by_tag_name
  end

  def filter_by_post_content
    return if params.dig(:q, :title_or_body).blank?

    keyword = params[:q][:title_or_body]
    @posts = @posts.where('posts.title LIKE :kw OR posts.body LIKE :kw', kw: "%#{keyword}%")
  end

  def filter_by_comment_content
    return if params.dig(:q, :comment_body).blank?

    keyword = params[:q][:comment_body]
    @posts = @posts.joins(:comments).where('comments.body LIKE ?', "%#{keyword}%")
  end

  def filter_by_username
    return if params.dig(:q, :username).blank?

    keyword = params[:q][:username]
    @posts = @posts.joins(user: :profile).where('profiles.name LIKE ?', "%#{keyword}%")
  end

  def filter_by_tag_name
    @posts = @posts.joins(:tags).where(tags: { name: params[:tag_name] }) if params[:tag_name].present?
  end
end
