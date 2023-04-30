DELIMITER //
CREATE PROCEDURE AddValidBooking (IN bookDate DATE, IN bookTable INT) 
	BEGIN 
		SET @yesrollback = IF(bookTable = ANY(SELECT TableNo FROM bookings WHERE DATE(bookDate) = BookingDate),0,1);
		SELECT MAX(BookingID)+1 FROM bookings INTO @newbookingID;
		SELECT MAX(CustomerID)+1 FROM customers INTO @newcustomerID;
		START TRANSACTION; 
			INSERT INTO customers(CustomerID,Name,Contact) 
				VALUES (@newcustomerID,0,0);
			INSERT INTO Bookings(BookingID,BookingDate,TableNo,Staff_StaffID,Customers_CustomerID) 
				VALUES (@newbookingID,DATE(bookDate),bookTable,3,@newcustomerID); 
			IF @yesrollback = 0 THEN
				ROLLBACK;
				SELECT CONCAT("Table ",bookTable," already booked for ", bookDate, "-[booking cancelled]") AS "Booking Confirmation"; 
			ELSE COMMIT; 
				SELECT CONCAT("Table ",bookTable," booked for ", bookDate) AS "Booking Confirmation"; 
			END IF; 
	END//
DELIMITER ;
CALL AddValidBooking('2023-12-1',4); 


DELIMITER //
CREATE PROCEDURE AddBooking(IN bookID INT, IN custID INT, IN tableNo INT, IN bookDate DATE)
BEGIN
	INSERT INTO Bookings(BookingID,BookingDate,TableNo,Staff_StaffID,Customers_CustomerID)
	VALUES (bookID,DATE(bookDate),tableNo,3,custID);
END//
DELIMITER ;

CALL AddBooking(16,23,5,'2023-06-19')

DELIMITER //
CREATE PROCEDURE UpdateBooking(IN bookID INT, IN bookDate DATE)
BEGIN
	UPDATE Bookings
    SET BookingDate = bookDate
    WHERE BookingID = bookID;
END //
DELIMITER ;

CALL UpdateBooking( 16, '2023-06-17')

DELIMITER //
CREATE PROCEDURE DeleteBooking(IN bookID INT)
BEGIN
	DELETE FROM Bookings
    WHERE BookingID = bookID;
END //
DELIMITER ;

CALL DeleteBooking(16)
