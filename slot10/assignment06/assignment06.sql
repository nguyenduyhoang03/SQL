create database BookStore

CREATE TABLE PublishingCompany (
	Company_ID INT IDENTITY (1, 1) primary key,
	Company_name NVARCHAR(50) NOT NULL,
	Address NVARCHAR(255) NOT NULL,
	Quantity INT NOT NULL
);

CREATE TABLE Catalogies (
	Catalog_ID INT IDENTITY (1, 1) primary key,
	Catalog_name NVARCHAR(50) NOT NULL
);

CREATE TABLE Author (
	Author_ID INT IDENTITY (1, 1) primary key,
	Author_name NVARCHAR(50) NOT NULL
);

CREATE TABLE Book (
	Book_ID NVARCHAR(20) primary key,
	Author_ID INT NOT NULL,
	Company_ID INT NOT NULL,
	Catalog_ID INT NOT NULL,
	Book_name NVARCHAR(50) NOT NULL,
	Summary_content NVARCHAR(MAX) NOT NULL,
	Publishing_year INT NOT NULL,
	Publication_time INT NOT NULL,
	UnitPrice MONEY NOT NULL,
	FOREIGN KEY(Author_ID) REFERENCES Author(Author_ID),
	FOREIGN KEY(Company_ID) REFERENCES PublishingCompany(Company_ID),
	FOREIGN KEY(Catalog_ID) REFERENCES Catalogies(Catalog_ID)
);

CREATE TABLE AuthorBook (
	Book_ID NVARCHAR(20),
	Author_ID INT,
	PRIMARY KEY (Book_ID, Author_ID),
	FOREIGN KEY(Book_ID) REFERENCES Book(Book_ID),
	FOREIGN KEY(Author_ID) REFERENCES Author(Author_ID)
);
-- 2) Viết lệnh SQL chèn vào các bảng của CSDL các dữ liệu mẫu
--PublishingCompany
INSERT INTO PublishingCompany
	VALUES ('Tri Thức', '53 Nguyễn Du, Hai Bà Trưng, Hà Nội', 100);
--Catalogies
INSERT INTO Catalogies 
	VALUES ('Khoa học xã hội');
--Author
INSERT INTO Author 
	VALUES ('Eran Katz');
--Book
INSERT INTO Book (Book_ID, Author_ID, Company_ID, Catalog_ID, Book_name, Summary_content, Publishing_year, Publication_time, UnitPrice) 
	VALUES ('B001', 1, 1, 1,'Trí tuệ Do Thái', 'Bạn có muốn biết: Người Do Thái sáng tạo ra cái gì và nguồn gốc
trí tuệ của họ xuất phát từ đâu không? Cuốn sách này sẽ dần hé lộ
những bí ẩn về sự thông thái của người Do Thái, của một dân tộc
thông tuệ với những phương pháp và kỹ thuật phát triển tầng lớp trí
thức đã được giữ kín hàng nghìn năm như một bí ẩn mật mang tính
văn hóa.', 2010, 1, 79000);

--3. Liệt kê các cuốn sách có năm xuất bản từ 2008 đến nay
SELECT * FROM Book
WHERE Publishing_year >= 2008; 
--4. Liệt kê 10 cuốn sách có giá bán cao nhất
SELECT MAX(UnitPrice) FROM Book

--5. Tìm những cuốn sách có tiêu đề chứa từ “tin học”
SELECT * FROM Book
WHERE Book_name Like '%tin học%';

--6. Liệt kê các cuốn sách có tên bắt đầu với chữ “T” theo thứ tự giá giảm dần
SELECT * FROM Book
WHERE Book_name LIKE 'T%'
order by book_name desc;
--7. Liệt kê các cuốn sách của nhà xuất bản Tri thức
SELECT * FROM Book b
INNER JOIN PublishingCompany pc ON pc.Company_ID = b.Company_ID
WHERE pc.Company_name = 'Tri thức';

--8. Lấy thông tin chi tiết về nhà xuất bản xuất bản cuốn sách “Trí tuệ Do Thái”
SELECT * FROM PublishingCompany
WHERE Company_ID IN (SELECT Company_ID FROM Book WHERE Book_name LIKE 'Trí tuệ Do Thái');

--9. Hiển thị các thông tin sau về các cuốn sách: Mã sách, Tên sách, Năm xuất bản, Nhà xuất bản, Loại sách
SELECT b.Book_ID, b.Book_name, b.Publishing_year, pc.Company_name, c.Catalog_name
FROM Book b
INNER JOIN Catalogies c ON c.Catalog_ID = b.Catalog_ID
INNER JOIN PublishingCompany pc ON pc.Company_ID = b.Company_ID;

--10. Tìm cuốn sách có giá bán đắt nhất
SELECT TOP 1 Book_name, UnitPrice FROM Book
ORDER BY UnitPrice DESC;
--11. Tìm cuốn sách có số lượng lớn nhất trong kho
SELECT TOP 1 b.Book_name, Book_name FROM Book b
INNER JOIN PublishingCompany pc ON pc.Company_ID = b.Company_ID
ORDER BY Quantity DESC;
 
--12. Tìm các cuốn sách của tác giả “Eran Katz”
SELECT * FROM Book b
JOIN Author a ON b.Author_ID = a.Author_ID
WHERE a.Author_name = 'Eran Katz';

--13. Giảm giá bán 10% các cuốn sách xuất bản từ năm 2008 trở về trước
UPDATE Book 
SET UnitPrice = UnitPrice * 0.9
WHERE Publishing_year <= 2008;

--14. Thống kê số đầu sách của mỗi nhà xuất bản
SELECT pc.Company_name, COUNT(*) FROM Book b
INNER JOIN PublishingCompany pc ON pc.Company_ID = b.Company_ID
GROUP BY pc.Company_name;

--15. Thống kê số đầu sách của mỗi loại sách
SELECT c.Catalog_name, COUNT(*) FROM Book b
INNER JOIN Catalogies c ON c.Catalog_ID = b.Catalog_ID
GROUP BY c.Catalog_name;

--16. Đặt chỉ mục (Index) cho trường tên sách
CREATE INDEX idx_BookName ON Book (Book_name);

--17. Viết view lấy thông tin gồm: Mã sách, tên sách, tác giả, nhà xb và giá bán
CREATE VIEW View_Infor_Book AS
SELECT b.Book_ID, b.Book_name, a.Author_name, pc.Company_name, b.UnitPrice
FROM Book b
INNER JOIN PublishingCompany pc ON pc.Company_ID = b.Company_ID
INNER JOIN Author a ON a.Author_ID = b.Author_ID;

--18. Viết Store Procedure:
--SP_Them_Sach: thêm mới một cuốn sách
CREATE PROCEDURE add_book
	@Book_ID NVARCHAR(20),
	@Author_ID INT,
	@Company_ID INT ,
	@Catalogi_ID INT ,
	@Book_name NVARCHAR(50),
	@Summary_content NVARCHAR(MAX),
	@Publishing_year INT ,
	@Publication_time INT ,
	@UnitPrice MONEY
AS
BEGIN
	IF EXISTS( SELECT * FROM Book WHERE Book_ID != @Book_ID AND @Author_ID IN (SELECT Author_ID FROM Author) 
				AND @Company_ID IN (SELECT Company_ID FROM PublishingCompany) AND @Catalogi_ID  IN (SELECT Catalog_ID FROM Catalogies) )
		INSERT INTO Book(Book_ID, Author_ID, Company_ID, Catalog_ID, Book_name, Summary_content, Publishing_year, Publication_time, UnitPrice) 
			VALUES  (@Book_ID, @Author_ID, @Company_ID, @Catalogi_ID, @Book_name, @Summary_content, @Publishing_year, @Publication_time, @UnitPrice);
	ELSE
	BEGIN
		PRINT 'Khong hop le'
	END
END;

--◦ SP_Tim_Sach: Tìm các cuốn sách theo từ khóa
CREATE PROCEDURE SearchBookByKeyword
	@Keyword NVARCHAR(50)
AS
BEGIN
	IF EXISTS (SELECT * FROM Book WHERE Book_name LIKE '%' + @Keyword + '%')
		SELECT * FROM Book WHERE Book_name LIKE '%' + @Keyword + '%'
	ELSE
	BEGIN
		PRINT 'No result'
	END
END;

--◦ SP_Sach_ChuyenMuc: Liệt kê các cuốn sách theo mã chuyên mục
CREATE PROCEDURE SearchByCatalog
	@Catalog_ID INT
AS
BEGIN
	IF EXISTS (SELECT * FROM Book WHERE @Catalog_ID IN ( SELECT Catalog_ID FROM Catalogies))
		SELECT * FROM Book WHERE @Catalog_ID IN ( SELECT Catalog_ID FROM Catalogies)
	BEGIN
		PRINT 'No result'
	END
END;

--19. Viết trigger không cho phép xóa các cuốn sách vẫn còn trong kho (số lượng > 0)
CREATE TRIGGER Delete_book
ON Book AFTER DELETE
AS
BEGIN
		IF EXISTS (SELECT * FROM PublishingCompany pc
					INNER JOIN deleted d ON d.Company_ID = pc.Company_ID
					WHERE pc.Quantity > 0
					)
	BEGIN
		RAISERROR('Not allowed to delete book have quantity > 0', 16, 1)
		ROLLBACK TRANSACTION
	END
END;

--20. Viết trigger chỉ cho phép xóa một danh mục sách khi không còn cuốn sách nào thuộc chuyên mục này.
CREATE TRIGGER delete_catalog
ON Catalogies AFTER DELETE
AS
BEGIN
	IF EXISTS ( SELECT * FROM Book b
				INNER JOIN deleted d ON b.Catalog_ID = d.Catalog_ID 
				)
	BEGIN
		RAISERROR('Only allow deleting a list of books when there are no more books in this category', 16, 1)
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		DELETE c
		FROM Catalogies c
		INNER JOIN deleted d ON C.Catalog_ID = d.Catalog_ID;
	END
END;

