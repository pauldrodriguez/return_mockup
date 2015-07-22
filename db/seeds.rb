# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Order.create(order_num: 12345, amount: 800.99, first_name: "paul",last_name: "rodriguez",discounts: 0.00,tax: 0.00,subtotal: 800.99)
OrderItem.create(order_id: 1,product_id: 1, order_num: 12345, product_name: "Product 1", size: "14Q", quantity: 3,original_price: 800.99,price: 800.99,status: "shipped")
OrderItem.create(order_id: 1,product_id: 2,order_num: 12345, product_name: "Product 2", size: "10A", quantity: 2,original_price: 700.99,price: 700.99,status:"shipped")
OrderItem.create(order_id: 1,product_id: 3,order_num: 12345, product_name: "Product 3", size: "10A", quantity: 2,original_price: 700.99,price: 700.99,status:"shipped")



Product.create(name: "Product 1", sku: "AGD1724M-RSTTE",image_front: "img_test_front.jpeg",image_back: "img_test_back.jpeg")
Product.create(name: "Product 2",sku: "ALX1419M-RSTTE",image_front: "img_test_front2.jpeg",image_back: "img_test_back2.jpeg")
Product.create(name: "Product 3",sku: "AQJ2226MX-RB/BK",image_front: "img_test_front3.jpeg",image_back: "img_test_back3.jpeg")