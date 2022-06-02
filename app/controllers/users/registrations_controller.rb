class Users::RegistrationsController < Devise::RegistrationsController
  def create
    user = User.new(user_params)
    if user.save
      render json: { message: 'Signed up successfully!' }, status: :created
    else
      render json: { error: { 'email or password' => 'is invalid' } }, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end