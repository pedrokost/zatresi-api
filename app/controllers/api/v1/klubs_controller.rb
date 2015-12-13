module Api
  module V1
    class KlubsController < ApplicationController
      def index
        klubs = Klub.where("? = ANY (categories)", category_param)

        data = Rails.cache.fetch("klubs/#{category_param}-#{klubs.count}-#{klubs.map(&:updated_at).max.to_i}") do
          serializer = ActiveModel::Serializer::ArraySerializer.new(klubs)
          ActiveModel::Serializer::Adapter.create(serializer).as_json
        end

        render json: data
      end

      def create
        editor = new_klub_param['editor']
        @klub = Klub.new(new_klub_param.except('editor'))
        @klub.editor_emails << editor
        @klub.send_review_notification

        render nothing: true
      end

      def update
        klub = Klub.where(slug: params[:id]).first
        klub.create_updates update_klub_param
        render nothing: true, status: :accepted
      end

      def find_by_slug
        klub = Klub.where(slug: params[:slug]).first
        render json: klub
      end

    private

      def category_param
        params.require(:category)
      end

      def new_klub_param
        params.require(:klub).permit(:name, :address, :town, :latitude, :longitude, :website, :facebook_url, :phone, :email, {:categories => []}, :editor)
      end

      def update_klub_param
        params.require(:klub).permit(:name, :address, :town, :latitude, :longitude, :website, :facebook_url, :phone, :email, {:categories => []}, :editor)
      end

    end
  end
end

