-- 2)
CREATE TABLE Customers (
	Customer_ID INT IDENTITY(1,1) primary key,
	Customer_name NVARCHAR(50) NOT NULL,
	Address NVARCHAR(255) NOT NULL,
	Birthday DATE NOT NULL
);

CREATE TABLE Phone_Numbers (
	Phone_ID INT IDENTITY(1,1) primary key,
	Customer_ID INT NOT NULL,
	Numbers INT NOT NULL,
	FOREIGN KEY(Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Customers
	VALUES ('Nguyễn Văn An', '111 Nguyễn Trãi, Thanh Xuân, Hà Nội', '1987-11-18');
SELECT * FROM Customers;

INSERT INTO Phone_Numbers
	VALUES  (1, 987654321),
			(1, 09873452),
			(1, 09832323),
			(1, 09434343);
SELECT * FROM Phone_Numbers;
--4. Viết các câu lênh truy vấn để
--a) Liệt kê danh sách những người trong danh bạ
SELECT * FROM Customers;
--b) Liệt kê danh sách số điện thoại có trong danh bạ
SELECT * FROM Phone_Numbers;
--5. Viết các câu lệnh truy vấn để lấy
--a) Liệt kê danh sách người trong danh bạ theo thứ thự alphabet
SELECT * FROM Customers
ORDER BY Customer_name ASC;
--b) Liệt kê các số điện thoại của người có tên là Nguyễn Văn An
SELECT * FROM Phone_Numbers pn
INNER JOIN Customers c ON c.Customer_ID = pn.Customer_ID
WHERE c.Customer_name = 'Nguyễn Văn An';
--c) Liệt kê những người có ngày sinh là 12/12/09
SELECT * FROM Customers
WHERE Birthday = '2009-12-12';
--6. Viết các câu lệnh truy vấn để
--a) Tìm số lượng số điện thoại của mỗi người trong danh bạ
SELECT c.Customer_name, COUNT(pn.Phone_ID)
FROM Phone_Numbers pn
INNER JOIN Customers c ON c.Customer_ID = pn.Customer_ID
GROUP BY c.Customer_name;
--b) Tìm tổng số người trong danh bạ sinh vào tháng 12.
SELECT COUNT(*) FROM Customers
WHERE MONTH(Birthday) = 12;
--c) Hiển thị toàn bộ thông tin về người, của từng số điện thoại.
SELECT * FROM Phone_Numbers pn
FULL JOIN Customers c ON c.Customer_ID = pn.Customer_ID;
--d) Hiển thị toàn bộ thông tin về người, của số điện thoại 123456789.
SELECT * FROM Customers c
INNER JOIN Phone_Numbers pn ON c.Customer_ID = pn.Customer_ID
WHERE pn.Numbers = 123456789;
--7. Thay đổi những thứ sau từ cơ sở dữ liệu
--a) Viết câu lệnh để thay đổi trường ngày sinh là trước ngày hiện tại
UPDATE Customers
SET Birthday = DATEADD(day, -1, GETDATE())
WHERE Birthday > GETDATE();
--b) Viết câu lệnh để xác định các trường khóa chính và khóa ngoại của các bảng
-- Khóa chính của bảng Customers
SELECT *
FROM sys.key_constraints
WHERE type = 'PK' AND parent_object_id = OBJECT_ID('customers')
--khóa chính bảng phoneNumbers
SELECT *
FROM sys.key_constraints
WHERE type = 'PK' AND parent_object_id = OBJECT_ID('phoneNumbers')
SELECT *
FROM sys.key_constraints
WHERE type = 'PK' AND parent_object_id = OBJECT_ID('product_type')
--foreign key của PhoneNumbers
SELECT *
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('PhoneNumbers')
--c) Viết câu lệnh để thêm trường ngày bắt đầu liên lạc
ALTER TABLE Customers
ADD Date_Start DATE;
SELECT * FROM Customers;
--8. Thực hiện các yêu cầu sau
--a) Thực hiện các chỉ mục sau(Index)
--◦ IX_HoTen : đặt chỉ mục cho cột Họ và tên
CREATE INDEX IDX_Name
ON Customers (Customer_name);
--◦ IX_SoDienThoai: đặt chỉ mục cho cột Số điện thoại
CREATE INDEX IDX_PhoneNumber
ON Phone_Numbers (Numbers);
--b) Viết các View sau:
--◦ View_SoDienThoai: hiển thị các thông tin gồm Họ tên, Số điện thoại
CREATE VIEW View_PhoneNumber AS
SELECT c.Customer_name, pn.Numbers
FROM Customers c
INNER JOIN Phone_Numbers pn ON c.Customer_ID = pn.Customer_ID;
--◦ View_SinhNhat: Hiển thị những người có sinh nhật trong tháng hiện tại (Họ tên, Ngày sinh, Số điện thoại)
CREATE VIEW View_Birthday AS
SELECT c.Customer_name, c.Birthday ,pn.Numbers
FROM Customers c
INNER JOIN Phone_Numbers pn ON c.Customer_ID = pn.Customer_ID
WHERE MONTH(Birthday) = GETDATE();
--c) Viết các Store Procedure sau:
--◦ SP_Them_DanhBa: Thêm một người mới vào danh bạ
CREATE Procedure add_Contact
	@Customer_name NVARCHAR(50),
	@Address NVARCHAR(255),
	@Birthday DATE
AS
BEGIN
	INSERT INTO Customers(Customer_name, Address, Birthday)
		VALUES (@Customer_name, @Address, @Birthday)
	BEGIN
	PRINT 'Add Success';
	END
END;
--◦ SP_Tim_DanhBa: Tìm thông tin liên hệ của một người theo tên (gần đúng)
CREATE Procedure Search_By_Name
	@Customer_name NVARCHAR(50)
AS
BEGIN
	IF EXISTS (
		SELECT *
		FROM Customers
		WHERE Customer_name LIKE '%' + @Customer_name + '%'
	)
	BEGIN
		SELECT *
		FROM Customers
		WHERE Customer_name LIKE '%' + @Customer_name + '%';
	END
	ELSE
	BEGIN
		PRINT 'No result'
	END
END;
