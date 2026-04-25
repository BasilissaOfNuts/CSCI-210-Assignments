-- Combined Inserts for restaurantproject
SET search_path TO restaurantproject;

-------------------------------------------------------------------------------
-- 1. CUSTOMERS
-------------------------------------------------------------------------------
INSERT INTO customer (fname, lname, email, phone_num, street, city, zip_code) VALUES 
('Stella', 'Song', 'icetechstudios123@gmail.com', '317-555-0199', '11200 Illinois St Apt 4B', 'Carmel', '46032'),
('Lythoniel', 'Coryell', 'lcoryell@example.com', '317-555-0244', '3400 Sycamore St', 'Zionsville', '46077'),
('Abdu', 'Eleida', 'abdu.e@example.com', '317-555-0311', '700 Mass Ave Unit 12', 'Indianapolis', '46204'),
('Joe', 'Perry', 'jperry@example.com', '317-555-0488', '1400 Rangeline Rd House 3', 'Carmel', '46033'),
('Daryn', 'Grover', 'dgrover@example.com', '317-555-0599', '6200 Broad Ripple Ave', 'Indianapolis', '46220'),
('Basil II', 'Macedonian', 'toobusywarringtofornicate958@byzantium.gov', '101-440-0099', 'Great Palace of Constantinople', 'Constantinople', '34122');

-------------------------------------------------------------------------------
-- 2. DISHES
-------------------------------------------------------------------------------
INSERT INTO dish (zh_name, en_name, price, available, category, zh_desc, en_desc) VALUES 
('酸菜鱼', 'Fish w/ Pickled Mustard Greens', 24.99, true, 'Seafood', '鲜嫩鱼片配以酸辣开胃的酸菜汤底', 'Tender fish slices in a tangy, spicy broth.'),
('拍黄瓜', 'Smashed Cucumber Salad', 8.99, true, 'Cold Appetizer', '清脆黄瓜拍碎，拌以蒜泥、香醋和香油', 'Crisp smashed cucumbers with garlic and sesame oil.'),
('爆炒腰花', 'Stir-fried Pork Kidneys', 19.99, true, 'Meat', '鲁菜经典，腰花鲜嫩脆爽', 'Shandong classic: tender and crisp scored pork kidneys.'),
('干锅花菜', 'Dry Pot Cauliflower', 15.99, true, 'Vegetable', '花菜与五花肉在干锅中煸炒', 'Cauliflower stir-fried with pork belly in a dry pot.'),
('山药木耳', 'Stir-fried Yam & Wood Ear', 14.99, true, 'Vegetable', '清淡爽口的山药与黑木耳同炒', 'Light stir-fry of Chinese yam and wood ear mushrooms.'),
('烤心管', 'Roasted Aorta Skewers', 12.99, true, 'BBQ/Snack', '炭火慢烤牛/猪心管，口感脆弹', 'Grilled beef/pork aortas with cumin seasoning.');

-------------------------------------------------------------------------------
-- 3. DISH OPTIONS
-------------------------------------------------------------------------------
INSERT INTO dish_option (zh_name, en_name, price, available) VALUES 
('加肉/加蛋白质', 'More meat / protein', 4.00, true),
('半份', 'Half portion', -5.00, true),
('微辣', 'Less Spicy', 0.00, true),
('特辣', 'More Spicy', 0.00, true),
('加米饭', 'Add rice', 2.00, true);

-------------------------------------------------------------------------------
-- 4. DISH RESTRICTIONS
-------------------------------------------------------------------------------
INSERT INTO dish_restriction (zh_name, en_name) VALUES 
('清真', 'Halal'),
('犹太洁食', 'Kosher'),
('素食', 'Vegetarian'),
('无坚果', 'Nut free'),
('无麸质', 'Gluten free');

-------------------------------------------------------------------------------
-- 5. MAPPINGS (Junction Tables)
-------------------------------------------------------------------------------
INSERT INTO dish_to_option (dish_id, opt_id)
SELECT d.dish_id, o.opt_id FROM dish d, dish_option o 
WHERE d.en_name IN ('Stir-fried Pork Kidneys', 'Fish w/ Pickled Mustard Greens') AND o.en_name = 'More meat / protein';

INSERT INTO dish_to_option (dish_id, opt_id)
SELECT d.dish_id, o.opt_id FROM dish d, dish_option o 
WHERE d.en_name = 'Fish w/ Pickled Mustard Greens' AND o.en_name = 'Half portion';

INSERT INTO dish_to_option (dish_id, opt_id)
SELECT d.dish_id, o.opt_id FROM dish d, dish_option o 
WHERE d.en_name IN ('Fish w/ Pickled Mustard Greens', 'Dry Pot Cauliflower', 'Roasted Aorta Skewers') 
AND o.en_name IN ('Less Spicy', 'More Spicy');

INSERT INTO dish_to_option (dish_id, opt_id) 
SELECT dish_id, (SELECT opt_id FROM dish_option WHERE en_name = 'Add rice') FROM dish;

INSERT INTO dish_to_restriction (dish_id, res_id)
SELECT d.dish_id, r.res_id FROM dish d, dish_restriction r
WHERE d.en_name IN ('Fish w/ Pickled Mustard Greens', 'Smashed Cucumber Salad', 'Stir-fried Yam & Wood Ear')
AND r.en_name IN ('Halal', 'Kosher', 'Gluten free');

INSERT INTO dish_to_restriction (dish_id, res_id)
SELECT d.dish_id, r.res_id FROM dish d, dish_restriction r
WHERE d.en_name IN ('Smashed Cucumber Salad', 'Stir-fried Yam & Wood Ear') AND r.en_name = 'Vegetarian';

INSERT INTO dish_to_restriction (dish_id, res_id)
SELECT d.dish_id, r.res_id FROM dish d, dish_restriction r
WHERE d.en_name != 'Smashed Cucumber Salad' AND r.en_name = 'Nut free';

-------------------------------------------------------------------------------
-- 6. ORDERS & INVOICES
-------------------------------------------------------------------------------

-- 6.1 STELLA'S ORDER
INSERT INTO "order" (cus_id, type, ord_split, table_num, ord_time) 
SELECT cus_id, 'DINE_IN', 1, 5, CURRENT_DATE + TIME '12:30:00' FROM customer WHERE email = 'icetechstudios123@gmail.com';

INSERT INTO invoice (ord_id, split_id, pay_type, pay_info, paid, create_time, paid_time)
VALUES (lastval(), 1, 'GOOGLE_PAY', 'icetechstudios123@gmail.com', true, CURRENT_DATE + TIME '12:30:00', CURRENT_DATE + TIME '13:15:00');

INSERT INTO order_line_item (ord_id, line_num, dish_id, split_id, quantity, price)
SELECT lastval(), 1, dish_id, 1, 1, price FROM dish WHERE en_name = 'Stir-fried Pork Kidneys';
INSERT INTO order_line_option (ord_id, line_num, opt_id, quantity, price)
SELECT lastval(), 1, opt_id, 1, price FROM dish_option WHERE en_name = 'More meat / protein';
INSERT INTO order_line_option (ord_id, line_num, opt_id, quantity, price)
SELECT lastval(), 1, opt_id, 2, price FROM dish_option WHERE en_name = 'Add rice';

INSERT INTO order_line_item (ord_id, line_num, dish_id, split_id, quantity, price)
SELECT lastval(), 2, dish_id, 1, 1, price FROM dish WHERE en_name = 'Roasted Aorta Skewers';
INSERT INTO order_line_item (ord_id, line_num, dish_id, split_id, quantity, price)
SELECT lastval(), 3, dish_id, 1, 1, price FROM dish WHERE en_name = 'Dry Pot Cauliflower';

-- 6.2 LYTHONIEL'S ORDER
INSERT INTO "order" (cus_id, type, ord_split, table_num, ord_time) 
SELECT cus_id, 'DINE_IN', 1, 6, CURRENT_DATE + TIME '18:00:00' FROM customer WHERE fname = 'Lythoniel';

INSERT INTO invoice (ord_id, split_id, pay_type, pay_info, paid, create_time, paid_time)
VALUES (lastval(), 1, 'CREDIT', 'VISA-4242-8888-JUNK', true, CURRENT_DATE + TIME '18:00:00', CURRENT_DATE + TIME '18:50:00');

INSERT INTO order_line_item (ord_id, line_num, dish_id, split_id, quantity, price)
SELECT lastval(), 1, dish_id, 1, 1, price FROM dish WHERE en_name = 'Stir-fried Pork Kidneys';
INSERT INTO order_line_option (ord_id, line_num, opt_id, quantity, price)
SELECT lastval(), 1, opt_id, 1, price FROM dish_option WHERE en_name = 'Add rice';

INSERT INTO order_line_item (ord_id, line_num, dish_id, split_id, quantity, price)
SELECT lastval(), 2, dish_id, 1, 1, price FROM dish WHERE en_name = 'Fish w/ Pickled Mustard Greens';
INSERT INTO order_line_option (ord_id, line_num, opt_id, quantity, price)
SELECT lastval(), 2, opt_id, 1, price FROM dish_option WHERE en_name = 'Less Spicy';
INSERT INTO order_line_option (ord_id, line_num, opt_id, quantity, price)
SELECT lastval(), 2, opt_id, 1, price FROM dish_option WHERE en_name = 'Add rice';

-- 6.3 ABDU & DARYN'S 3-WAY SPLIT
INSERT INTO "order" (cus_id, type, ord_split, table_num, ord_time) 
SELECT cus_id, 'DINE_IN', 3, 10, CURRENT_DATE + TIME '19:15:00' FROM customer WHERE fname = 'Abdu';

-- Split 1 (Daryn)
INSERT INTO invoice (ord_id, split_id, pay_type, pay_info, paid, create_time, paid_time) VALUES 
(lastval(), 1, 'DEBIT', 'DARYN-DEBIT-9999', true, CURRENT_DATE + TIME '19:15:00', CURRENT_DATE + TIME '19:55:00');
-- Split 2 (Stella)
INSERT INTO invoice (ord_id, split_id, pay_type, pay_info, paid, create_time, paid_time) VALUES 
(lastval(), 2, 'PAYPAL', 'icetechstudios123@gmail.com', true, CURRENT_DATE + TIME '19:15:00', CURRENT_DATE + TIME '19:55:25');
-- Split 3 (Abdu)
INSERT INTO invoice (ord_id, split_id, pay_type, pay_info, paid, create_time, paid_time) VALUES 
(lastval(), 3, 'CASH', 'CASH', true, CURRENT_DATE + TIME '19:15:00', CURRENT_DATE + TIME '19:55:50');

INSERT INTO order_line_item (ord_id, line_num, dish_id, split_id, quantity, price)
SELECT lastval(), 1, dish_id, 1, 1, price FROM dish WHERE en_name = 'Fish w/ Pickled Mustard Greens';
INSERT INTO order_line_option (ord_id, line_num, opt_id, quantity, price)
SELECT lastval(), 1, opt_id, 1, price FROM dish_option WHERE en_name = 'Less Spicy';
INSERT INTO order_line_option (ord_id, line_num, opt_id, quantity, price)
SELECT lastval(), 1, opt_id, 1, price FROM dish_option WHERE en_name = 'More meat / protein';
INSERT INTO order_line_option (ord_id, line_num, opt_id, quantity, price)
SELECT lastval(), 1, opt_id, 1, price FROM dish_option WHERE en_name = 'Add rice';

INSERT INTO order_line_item (ord_id, line_num, dish_id, split_id, quantity, price)
SELECT lastval(), 2, dish_id, 2, 1, price FROM dish WHERE en_name = 'Stir-fried Yam & Wood Ear';
INSERT INTO order_line_option (ord_id, line_num, opt_id, quantity, price)
SELECT lastval(), 2, opt_id, 1, price FROM dish_option WHERE en_name = 'Add rice';

INSERT INTO order_line_item (ord_id, line_num, dish_id, split_id, quantity, price)
SELECT lastval(), 3, dish_id, 2, 1, price FROM dish WHERE en_name = 'Smashed Cucumber Salad';

INSERT INTO order_line_item (ord_id, line_num, dish_id, split_id, quantity, price)
SELECT lastval(), 4, dish_id, 3, 1, price FROM dish WHERE en_name = 'Dry Pot Cauliflower';
INSERT INTO order_line_option (ord_id, line_num, opt_id, quantity, price)
SELECT lastval(), 4, opt_id, 1, price FROM dish_option WHERE en_name = 'More Spicy';
INSERT INTO order_line_option (ord_id, line_num, opt_id, quantity, price)
SELECT lastval(), 4, opt_id, 1, price FROM dish_option WHERE en_name = 'Add rice';

-- 6.4 BASIL II
INSERT INTO "order" (cus_id, type, ord_split, table_num, ord_time) 
SELECT cus_id, 'TAKEOUT', 1, NULL, CURRENT_DATE + TIME '20:45:00' FROM customer WHERE fname = 'Basil II';

INSERT INTO invoice (ord_id, split_id, pay_type, pay_info, paid, create_time, paid_time)
VALUES (lastval(), 1, 'CASH', 'Imperial Byzantine Armor Left at Counter', true, CURRENT_DATE + TIME '20:45:00', CURRENT_DATE + TIME '21:20:00');

INSERT INTO order_line_item (ord_id, line_num, dish_id, split_id, quantity, price, notes)
SELECT lastval(), 1, dish_id, 1, 200, price, 
'To sustain morale during the logistics snags of the Siege of Tripoli. Customer paid in Regalian Lamellar Armor.'
FROM dish WHERE en_name = 'Roasted Aorta Skewers';