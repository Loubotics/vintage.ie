class ItemsController < ApplicationController
	before_action :authenticate_merchant!, only: [:update, :create, :new, :edit, :destroy]
	before_action :correct_merchant?, only: [:update, :edit, :create, :new, :destroy]

	def correct_merchant?
		redirect_to shop_items_path(params[:shop_id]) unless current_merchant == Shop.find(params[:shop_id]).merchant
	end

	def index
		if params[:shop_id]
			@params = params
			@shop = Shop.find(params[:shop_id])
			@items = @shop.items
			@shop_items_photos = []
			@items.each do |item|
				item.photos.each do |photo|
					photos << photo
				end
			end
			@shop_items_photos
		else
			@shop_items_photos = Photo.all.where(imageable_type: 'Item')
			@items = Item.all
		end
	end

	def show
		@params = params
		@item = Item.find(params[:id])
		@photos = @item.photos
	end

	def edit
		@shop = Shop.find(params[:shop_id])
		@item = Item.find(params[:id])
		@context = Shop.find(params[:shop_id])
		@photos = @item.photos.all
		@photo = @item.photos.new
		flash[:notice] = params
	end

	def new
		@context = Shop.find(params[:shop_id])
		@item = @context.items.new
		@photo = @context.photos.new
		flash[:notice] = params
		@photos = @context.photos.all
		
		
	end

	def create
		@item = Item.new(item_params)
		@shop = Shop.find(item_params[:shop_id])
		if @item.save
			flash[:success] = 'Item created succesfully'
			redirect_to edit_shop_item_path(@shop, @item)
		else
			flash[:danger] = "Couldn't create item #{@item.errors.full_messages}"
			render 'new'
		end
	end

	def update
		@item = Item.find(params[:id])
		@shop = Shop.find(item_params[:shop_id])
		if @item.update_attributes(item_params)
			flash[:success] = "Item updated succesfully"
			redirect_to edit_shop_item_path(@shop, @item)
		else
			flash[:danger] = "Couldn't update item #{@item.errors.full_messages}"
			render 'edit'
		end
	end

	def destroy
		@item.destroy
		redirect_to shop_items_path
	end

	private

	def item_params
		params.require(:item).permit!
	end
end
