class Admin::UsersController <  ApplicationController


  def index
    per_page = (params[:per_page] || 10).to_i
    page = (params[:page] || 1).to_i
    scope = User
    @search_text = params[:search_text]

    if @search_text
      scope = scope.search_user_name(scope,@search_text)
    else
      scope = scope.select("users.*")
    end
    Array
    @users = scope.order(sort_column(User) + " " + sort_direction).
        paginate(:per_page => per_page, :page => page)
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    user_role_ids = params[:user].delete(:role_ids)
    user_roles = Role.where(:id => user_role_ids)

    @user = User.new(params[:user])
    @user.roles << user_roles
    @user.password = rand(999999).to_s.center(10, rand(9).to_s)

    if @user.save
      @user.send_new_user_notifications
      redirect_to admin_users_path, notice: 'User was created Successfully.'
    else
      redirect_to new_admin_user_path, notice: 'User creation Failed'
    end
  end

  def update
    @user = User.find(params[:id])

    user_role_ids = params[:user].delete(:role_ids)
    user_roles = Role.where(:id => user_role_ids)

    @user.update_attributes(params[:user])

    @user.roles = user_roles
    @user.password = rand(999999).to_s.center(10, rand(9).to_s)

    if @user.save
      @user.send_new_user_notifications
      redirect_to admin_users_path, notice: 'User was updated Successfully.'
    else
      redirect_to new_admin_user_path, notice: 'User updation Failed'
    end
  end



end