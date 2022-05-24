class Users::RegistrationsController < Devise::RegistrationsController
  def create
    user = User.new(user_params)
    if user.save
      render json: { msg: "Signed up succesfully!" }
    else
      render json: { errors: { "email or password" => ["is invalid"] } }, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end