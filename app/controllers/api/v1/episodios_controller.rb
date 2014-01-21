module Api
  module V1
    class EpisodiosController < ApplicationController
      respond_to :json
      before_filter :restrict_access

      def show
        respond_with Episodio.find(params[:id])
      end

      def search
        begin
          date = params[:exibicao] ? params[:exibicao].to_date : Date.today
          respond_with Episodio.where(:estreia => date.beginning_of_day..date.end_of_day)
        rescue => e
          head :bad_request
        end
      end

      private

      def restrict_access
        api_key = ApiKey.find_by_access_token(params[:access_token])
        head :unauthorized unless api_key
      end
    end
  end
end