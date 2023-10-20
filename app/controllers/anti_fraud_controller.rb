class AntiFraudController < ApplicationController
    protect_from_forgery with: :null_session

    def check_transaction
      user = User.find_by(id: transaction_params[:user_id])
  
      if user.nil?
        render json: { error: "Usuário não encontrado" }, status: :unprocessable_entity
        return
      end
  
      recommendation = Transactions::CheckRecommendation.new(user, transaction_params).call
  
      render json: { transaction_id: transaction_params[:transaction_id], recommendation: recommendation }
    end
  
    private
  
    def transaction_params
      params.permit(
        :transaction_id,
        :merchant_id,
        :user_id,
        :card_number,
        :transaction_date,
        :transaction_amount,
        :device_id
      )
    end
  end