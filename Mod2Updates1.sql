CREATE VIEW OrdersView AS 
SELECT OrderID, TotalCost, Quantity 
FROM orders WHERE Quantity > 2;

CREATE VIEW CustomersView AS 
SELECT customers.CustomerID, customers.Name,
orders.OrderID, orders.TotalCost,
menu.MenuName, menuitems.Courses, menuitems.starters
FROM customers 
INNER JOIN orders ON customers.CustomerID = orders.Customers_CustomerID
INNER JOIN menu ON orders.Menu_MenuID
INNER JOIN menuitems ON menuitems.MenuItemsID = menu.MenuItems_MenuItemsID
WHERE orders.TotalCost > 150
ORDER BY orders.TotalCost ASC;

CREATE VIEW ItemsView AS
SELECT menu.MenuName FROM menu JOIN orders
ON menu.MenuID = orders.Menu_MenuID
WHERE orders.OrderID = ANY(SELECT OrderID FROM Orders WHERE Quantity > 2);

DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN SELECT MAX(Quantity)
FROM Orders;
END//
DELIMITER ;

PREPARE GetOrderDetail FROM 'SELECT orders.OrderID, orders.Quantity, orders.TotalCost FROM orders JOIN customers WHERE customers.CustomerID = ?';

DELIMITER //
CREATE PROCEDURE CancelOrder(IN custID INT)
BEGIN
DELETE FROM customers WHERE CustomerID = custID;
SELECT CONCAT("Order ",custID," has been removed") AS "Cancellations";
END
DELIMITER ;


















