class OrdersController < ApplicationController
  # before_action :authenticate_user!
  # load_and_authorize_resource

  def index
    @orders = Order.where(status: [0,1])
    render json: @orders
  end

  def show
    render json: @order
  end

  def create
    @order = Order.new(order_params)
    @order.status = 0
    item_ids = JSON.parse(params[:item_ids])
    @order.total_cost = calculate_total_cost(item_ids)

    if @order.save
      create_order_items(item_ids, @order.id)
      render json: @order, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy
    head :no_content
  end

  private

  def order_params
    params.permit(:customer_name, :paid)
  end
  
  def calculate_total_cost(item_ids)
    items = Item.where(id: item_ids)
    total_cost = items.sum(:price)
    
    total_tax_cost = items.sum { |item| (item.tax_rate / 100) * item.price }
    total_discount_cost=0
    
    items.each do |item|
      if item.discount_item_id.present?
        discount_item = Item.find(item.discount_item_id)
        if items.include?(discount_item) && item.discount_percent?
          total_discount_cost += item.price * (item.discount_percent.to_f / 100.0)
        end
      end
    end
    
    total_cost += total_tax_cost
    total_cost -= total_discount_cost
    
    total_cost
  end

  def create_order_items(item_ids, order_id)
    item_ids.each do |item_id|
      OrderItem.create(order_id: order_id, item_id: item_id, quantity: 1)
    end
  end
end
