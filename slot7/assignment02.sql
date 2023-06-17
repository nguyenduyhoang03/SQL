create table Manufacturers(
	Manufacturer_id int primary key not null,
	Manufacturer_Name varchar(50) not null,
	Address varchar(100) not null,
	Phone varchar(20) not null
)
create table Products(
	Product_id int primary key not null,
	unique(product_id),
	Product_name varchar(50) not null,
	description varchar(200) not null,
	Unit varchar(30) not null,
	price money not null,
	Quantity int not null,
	Manufacturer_id int not null,
	foreign key (Manufacturer_id) references Manufacturers(Manufacturer_id)
);
--3.Viết các câu lệnh để thêm dữ liệu vào các bảng
INSERT INTO Manufacturers (Manufacturer_id,Manufacturer_Name,Address,Phone)
values (123,'Asus','USA',983232)

INSERT INTO Products (Product_id,Product_name,description,Unit,price,Quantity,Manufacturer_id)
values  (1,'May tinh T450','May cu','chiec',1000,10,123),
		(2,'Dien thoai Nokia 5670','dien thoai hot','chiec',200,200,123),
		(3,'May in Samsung 450','may in trung binh','chiec',100,10,123);

--4.Viết các câu lênh truy vấn để
--a)Hiển thị tất cả các hãng sản xuất.
Select * from Manufacturers
--b)Hiển thị tất cả các sản phẩm.
select * from Products

--5. Viết các câu lệnh truy vấn để 
--a)Liệt kê danh sách hãng theo thứ thự ngược với alphabet của tên
select Manufacturer_name from Manufacturers
order by Manufacturer_Name desc
--b)Liệt kê danh sách sản phẩm của cửa hàng theo thứ thự giá giảm dần
select * from Products
order by price desc
--c)Hiển thị thông tin của hãng Asus.
select * from Manufacturers
where Manufacturer_Name = 'Asus'
--d) Liệt kê danh sách sản phẩm còn ít hơn 11 chiếc trong kho
select * from Products
where Quantity < 11
--e) Liệt kê danh sách sản phẩm của hãng Asus
select * from Products
where Manufacturer_id = 123
--6.Viết các câu lệnh truy vấn để lấy
--a)Số hãng sản phẩm mà cửa hàng có.
select count(distinct manufacturer_id) from Manufacturers
--b)Số mặt hàng mà cửa hàng bán.
select count(Product_id) from Products
--c)Tổng số loại sản phẩm của mỗi hãng có trong cửa hàng.
select m.Manufacturer_name,Count(*) from Products P
join Manufacturers m ON m.Manufacturer_id = P.Manufacturer_id
group by Manufacturer_Name
--d) Tổng số đầu sản phẩm của toàn cửa hàng
select Sum(quantity) from Products
--7)Thay đổi những thay đổi sau trên cơ sở dữ liệu
--a)Viết câu lệnh để thay đổi trường giá tiền của từng mặt hàng là dương(>0).
update Products
set price = abs(price)
where price < 0
--b) Viết câu lệnh để thay đổi số điện thoại phải bắt đầu bằng 0
update Manufacturers
set phone = '0' + SUBSTRING(phone,1,len(phone))
where phone not like '0%';
--c)Viết các câu lệnh để xác định các khóa ngoại và khóa chính của các bảng.--xác định pk của manufacturersSELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_NAME = 'Manufacturers' AND CONSTRAINT_NAME LIKE 'PK_%';
--xác định pk của productsSELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_NAME = 'Products' AND CONSTRAINT_NAME LIKE 'PK_%';
--xác định fk của productsSELECT 
    OBJECT_NAME(f.parent_object_id) AS TABLE_NAME,
    COL_NAME(fc.parent_object_id, fc.parent_column_id) AS COLUMN_NAME,
    OBJECT_NAME(f.referenced_object_id) AS REFERENCED_TABLE_NAME,
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS REFERENCED_COLUMN_NAME
FROM 
    sys.foreign_keys AS f
INNER JOIN 
    sys.foreign_key_columns AS fc ON f.object_id = fc.constraint_object_id
WHERE 
    OBJECT_NAME(f.parent_object_id) = 'Products' AND 
    COL_NAME(fc.parent_object_id, fc.parent_column_id) = 'Manufacturer_id';
--8) Thực hiện các yêu cầu sau/* a)Thiết lập chỉ mục (Index) cho các cột sau: Tên hàng và Mô tả hàng để tăng hiệu suất truy vấn dữ liệu từ 2 cột này */create index idx_product_name ON products(product_name);create index idx_description ON products(description);--b)Viết các View sau--View_SanPham: với các cột Mã sản phẩm, Tên sản phẩm, Giá bánGOcreate view products_view ASselect product_id,product_name,pricefrom Products--View_SanPham_Hang: với các cột Mã SP, Tên sản phẩm, Hãng sản xuấtGOcreate View prd_of_manufacturers ASselect p.product_id,p.product_name,m.manufacturer_namefrom Products pjoin Manufacturers m ON m.Manufacturer_id = p.Manufacturer_id--c)Viết các Store Procedure sau:--SP_SanPham_TenHang: Liệt kê các sản phẩm với tên hãng truyền vào storeGOcreate procedure products_manufacturers @manufacturer varchar(50)asbegin	select Product_name,price from Products p	join Manufacturers m ON p.Manufacturer_id = m.Manufacturer_id	where @manufacturer = m.Manufacturer_Nameend--SP_SanPham_Gia: Liệt kê các sản phẩm có giá bán lớn hơn hoặc bằng giá bán truyền vàogocreate procedure product_price @price moneyasbegin	select product_name,price from Products	where price >= @priceend--SP_SanPham_HetHang: Liệt kê các sản phẩm đã hết hàng (số lượng = 0)gocreate procedure product_SoldOut asbegin	select product_name,price,quantity from Products	where Quantity = 0end--d) viết các trigger sau:--TG_Xoa_Hang: Ngăn không cho xóa hãngcreate trigger not_deleteOn manufacturersinstead of deleteasbegin	RAISERROR('Ai cho xóa tên hãng mà xóa?',16,1);end--◦ TG_Xoa_SanPham: Chỉ cho phép xóa các sản phẩm đã hết hàng (số lượng = 0)CREATE TRIGGER Delete_product
ON Products
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM deleted WHERE Quantity > 0)
    BEGIN
        RAISERROR ('Không thể xóa sản phẩm còn hàng', 16, 1)
    END
    ELSE
    BEGIN
        DELETE FROM Products WHERE Product_Id IN (SELECT Product_Id FROM deleted)
    END
END




