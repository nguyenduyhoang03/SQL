create database assignment01
use assignment01
go
--2
create table customers(
 Customer_id int primary key not null,
 unique(customer_id),
 Customer_Name varchar(50) not null,
 Phone varchar(10) not null,
 Address varchar(100) not null
)
create table Orders(
 Order_id int primary key not null,
 Customer_id int not null,
 foreign key (Customer_id) references Customers(Customer_id),
 Order_Date date not null
)
create table Products (
 Product_id int primary key not null,
 unique(Product_id),
 Product_Name varchar(30) not null,
 UnitPrice money not null,
 Unit varchar(20) not null,
 Description varchar(500)
)
CREATE TABLE OrdersDetails (
	Order_ID INT NOT NULL,
	Product_ID INT NOT NULL,
	UnitPrice MONEY NOT NULL,
	Quantity INT NOT NULL,
	PRIMARY KEY (Order_ID, Product_ID),
	CONSTRAINT Order_ID FOREIGN KEY(Order_ID) REFERENCES Orders(Order_ID),
	CONSTRAINT FK_Product_ID FOREIGN KEY(Product_ID) REFERENCES Products(Product_ID)
);
----3
INSERT INTO customers(customer_id,Customer_Name,Phone,address)
values(01,'Nguyễn Văn An',0987654321,'111,Nguyễn Trãi,Thanh Xuân, Hà Nội');
INSERT INTO Orders (Order_id,Customer_id,Order_Date)
values(123,01,'11-18-09')
INSERT INTO Products(Product_id,Product_Name,UnitPrice,Unit,Description)
values(01,'Máy tính T450',1000,'chiếc','Máy nhập mới'),
	  (02,'Điện thoại Nokia 5670',200,'chiếc','Điện thoại đang hot'),
	  (03,'Máy in Samsung 450',100,'chiếc','máy in đang ế')
INSERT INTO OrdersDetails (Order_id,Product_id,Unitprice,Quantity)
values (123,01,1000,1),
		(123,02,200,2),
		(123,03,100,1)

--4
--a)
select c.Customer_id,o.Order_id,c.Customer_Name,c.Phone,c.address
from customers c
inner join Orders o ON c.Customer_id = o.Customer_id;
--b)
select * from Products;
--c)
select * from orders;

--5
--a)
select * from customers 
order by customers.Customer_Name;
--b)
select * from Products
order by Products.UnitPrice DESC;
--c)
select c.customer_name,p.product_id,p.product_name,unit,p.unitPrice
from Products p
inner join OrdersDetails od ON od.Product_ID = p.Product_id
inner join orders o ON od.Order_ID = o.order_id
inner join customers c ON c.Customer_id = o.Customer_id

--6)
--a)
select COUNT(DISTINCT customer_id) from Orders
--b)
select COUNT(distinct product_id) from Products
--c)
select order_id, SUM(Unitprice*Quantity) from OrdersDetails
Group by Order_ID
--7)
--a)
UPDATE Products
SET UnitPrice = ABS(UnitPrice)
WHERE UnitPrice < 0;
--b)
UPDATE Orders
SET Order_Date = DATEADD(day,-1,GETDATE())
WHERE Order_Date > GETDATE()
--c)
ALTER TABLE Products
ADD Manufacture_Date Date;

--8
--a)Đặt chỉ mục (index) cho cột Tên hàng và Người đặt hàng để tăng tốc độ truy vấn dữ liệu trên các cột này
create index idx_Product_Name ON Products(Product_name);
create index idx_Customer_Name ON Customers(Customer_name);
/* b) Xây dựng các view sau đây:
◦ View_KhachHang với các cột: Tên khách hàng, Địa chỉ, Điện thoại
◦ View_SanPham với các cột: Tên sản phẩm, Giá bán
◦ View_KhachHang_SanPham với các cột: Tên khách hàng, Số điện thoại, Tên sản
phẩm, Số lượng, Ngày mua*/	
-- View_KhachHang với các cột: Tên khách hàng, Địa chỉ, Điện thoại
GO
Create View Customer_View AS
select Customer_name,address,Phone
from customers
-- View_SanPham với các cột: Tên sản phẩm, Giá bán
GO
create view Product_View AS
Select Product_name,UnitPrice
from Products
--View_KhachHang_SanPham với các cột: Tên khách hàng, Số điện thoại, Tên sản phẩm, Số lượng, Ngày mua
GO
create view Cus_Prud_View AS
Select C.Customer_name,C.Phone,P.Product_name,Od.Quantity,O.Order_date
from customers C
inner join Orders o ON c.Customer_id = O.Customer_id
inner join OrdersDetails Od ON Od.Order_ID = O.Order_id
inner join Products P ON p.Product_id = Od.Product_id
--c)Viết store prucedure
--tìm khách hàng theo mã khách hàng
GO
create procedure SearchCusByID @customer_id int
as
begin
	select * from customers
	where Customer_id = @Customer_id
end
--Tìm thông tin khách hàng theo mã hóa đơn
GO
create procedure SearchCusByOrderId @Order_id int
as
begin
	select * from customers C
	join Orders O ON C.Customer_id = O.Customer_id
	where @Order_id = O.Order_id
end
--SP_SanPham_MaKH: Liệt kê các sản phẩm được mua bởi khách hàng có mã được truyền vào Store.GOCreate Procedure SearchProductByCusID @customer_id int
as
begin
	select P.product_name,p.description,od.Quantity,od.UnitPrice 
	from OrdersDetails od
	join Orders O ON O.Order_id = od.Order_ID
	join Products p ON p.Product_id = od.Product_ID
	where O.Customer_id = @customer_id
END



	
	

