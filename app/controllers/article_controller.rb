class ArticleController < ApplicationController

  skip_before_filter  :authenticate_user!, :only => [:index,:show]

  MODEL_CLASS = Article

  def index
    require_permission(User::PERMISSIONS[:ARTICLE][:VIEW],MODEL_CLASS)

    page = (params[:page] || 1).to_i
    @articles = Article.allowed(current_user).paginate(:per_page => 10  , :page => page)
  end

  def mark_complete
    @article = Article.find(params[:id])
    @article.status = Article::STATE[:complete]
    @article.save
    redirect_to article_index_path
  end

  def publish
    require_permission(User::PERMISSIONS[:ARTICLE][:PUBLISH],MODEL_CLASS)
    @article = Article.find(params[:id])
    @article.status = Article::STATE[:publish]
    flag = @article.save
    redirect_to article_index_path
  end

  def new
    require_permission(User::PERMISSIONS[:ARTICLE][:CREATE],MODEL_CLASS)
    @article = Article.new
  end

  def edit
    require_permission(User::PERMISSIONS[:ARTICLE][:EDIT],MODEL_CLASS)
    @article = Article.find(params[:id])
  end

  def create
    require_permission(User::PERMISSIONS[:ARTICLE][:CREATE],MODEL_CLASS)
    @article = Article.new(params[:article])
    @article = build_article(@article,params)

    if @article.save
      redirect_to article_index_path, notice: 'Article was created Successfully.'
    else
      render action: "edit"
    end
  end

  def update
    require_permission(User::PERMISSIONS[:ARTICLE][:CREATE],MODEL_CLASS)
    @article = Article.find(params[:id])
    if @article.user_id != current_user.id
      redirect_to  global_path(:unauthorized_path)
    end
    @article = build_article(@article,params)

    if @article.save
      redirect_to article_index_path, notice: 'Article was updated Successfully.'
    else
      flash[:error]= 'Article updation Failed'
      redirect_to edit_article_path(@article)
    end
  end

  def show
    @article = Article.find(params[:id])
    @user = User.find(@article.user_id)
  end

  protected

  def build_article article,params
    article.title = params[:article][:title]
    article.body = params[:article][:body]
    article.user_id = current_user.id
    article.status = Article::STATE[:draft]
    article
  end

  def check_user_permission

  end

end

