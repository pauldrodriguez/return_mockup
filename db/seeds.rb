# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Order.create(order_num: 12345, amount: 800.99, first_name: "paul",last_name: "rodriguez",discounts: 0.00,tax: 0.00,subtotal: 800.99)
OrderItem.create(order_id: 1, order_num: 12345, product_name: "Product 1", size: "14Q", quantity: 1,original_price: 800.99,price: 800.99)
OrderItem.create(order_id: 1,order_num: 12345, product_name: "Product 2", size: "10A", quantity: 2,original_price: 700.99,price: 700.99)