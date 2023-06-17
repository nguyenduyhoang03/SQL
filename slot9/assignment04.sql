create table product_type(
	type_id varchar(50) primary key,
	type_name varchar(50) not null,
)

create table responsibility_person(
	resp_id int primary key,
	resp_name varchar(50) not null
)

create table products(
	product_id varchar(50) primary key,
	production_date date not null,
	type_id varchar(50),
	foreign key (type_id) references product_type(type_id),
	resp_id int,
	foreign key (resp_id) references responsibility_person(resp_id)
)
--3.Viết các câu lệnh để thêm dữ liệu vào các bảng
insert into product_type (type_id,type_name)
values('Z37E','May tinh xach tay Z37')
insert into responsibility_person (resp_id,resp_name)
values(987688,'Nguyen Van An')
insert into products (product_id,production_date)
values ('Z37 111111',2009-12-12)
--4.Viết các câu lênh truy vấn để
--a) Liệt kê danh sách loại sản phẩm của công ty.
select * from product_type
--b) Liệt kê danh sách sản phẩm của công ty.
select * from products
--c) Liệt kê danh sách người chịu trách nhiệm của công ty.select * from responsibility_person--5. Viết các câu lệnh truy vấn để lấy--a) Liệt kê danh sách loại sản phẩm của công ty theo thứ tự tăng dần của tênselect * from product_typeorder by type_name --b) Liệt kê danh sách người chịu trách nhiệm của công ty theo thứ tự tăng dần của tên.select * from responsibility_personorder by resp_name--c) Liệt kê các sản phẩm của loại sản phẩm có mã số là Z37E.select * from products pjoin product_type pt ON pt.type_id = p.type_idwhere p.type_id = 'Z37E';--d) Liệt kê các sản phẩm Nguyễn Văn An chịu trách nhiệm theo thứ tự giảm đần của mã.select * from products pjoin responsibility_person rp ON rp.resp_id = p.resp_idwhere resp_name = 'Nguyen Van An'order by product_id desc;--6. Viết các câu lệnh truy vấn để--a) Số sản phẩm của từng loại sản phẩm.select pt.type_id,count(product_id) from products pjoin product_type pt ON pt.type_id = p.type_id--b) Số loại sản phẩm trung bình theo loại sản phẩmSELECT pt.type_name, AVG(count_type) AS avg_prod_type
FROM product_type pt
JOIN (
    SELECT type_id, COUNT(*) AS count_type
    FROM products
    GROUP BY type_id
) p ON pt.type_id = p.type_id
GROUP BY pt.type_name;
--c)Hiển thị toàn bộ thông tin về sản phẩm và loại sản phẩm.
select * from products p
join product_type pt ON pt.type_id = p.type_id
--d) Hiển thị toàn bộ thông tin về người chịu trách nhiêm, loại sản phẩm và sản phẩm.
select * from products p
join product_type pt ON pt.type_id = p.type_id
join responsibility_person rp ON rp.resp_id = p.resp_id
--7. Thay đổi những thứ sau từ cơ sở dữ liệu
--a) Viết câu lệnh để thay đổi trường ngày sản xuất là trước hoặc bằng ngày hiện tại.
UPDATE Products 
SET production_date = DATEADD(day, -1, GETDATE()) 
WHERE production_date > GETDATE();
--b) Viết câu lệnh để xác định các trường khóa chính và khóa ngoại của các bảng.
-- Xem pk của bảng .
--bảng product_type
SELECT *
FROM sys.key_constraints
WHERE type = 'PK' AND parent_object_id = OBJECT_ID('product_type')
-- bảng responsibility_person
SELECT *
FROM sys.key_constraints
WHERE type = 'PK' AND parent_object_id = OBJECT_ID('responsibility_person')
-- bảng products
SELECT *
FROM sys.key_constraints
WHERE type = 'PK' AND parent_object_id = OBJECT_ID('products')
--xem fk của bảng
SELECT *
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('products')
--c) Viết câu lệnh để thêm trường phiên bản của sản phẩm.
alter table products
add product_version varchar(50)
--8. Thực hiện các yêu cầu sau
--a) Đặt chỉ mục (index) cho cột tên người chịu trách nhiệm
create index idx_resp_name ON responsibility_person(resp_name)
--b) Viết các View sau:--◦ View_SanPham: Hiển thị các thông tin Mã sản phẩm, Ngày sản xuất, Loại sản phẩm
create view products_view AS
select p.product_id,p.production_date,pt.type_id from products p
join product_type pt ON pt.type_id = p.type_id
--◦ View_SanPham_NCTN: Hiển thị Mã sản phẩm, Ngày sản xuất, Người chịu trách nhiệm
create view resp_product_view as
select p.product_id,p.production_date,rp.resp_name from products p
join responsibility_person rp ON rp.resp_id = rp.resp_id
--◦ View_Top_SanPham: Hiển thị 5 sản phẩm mới nhất (mã sản phẩm, loại sản phẩm, ngày sản xuất)CREATE VIEW View_Top_Products
AS
SELECT TOP 5 p.product_id, pt.type_name, p.production_date
FROM products p
INNER JOIN product_type pt ON p.type_id = pt.type_id
ORDER BY p.production_date DESC
--c) Viết các Store Procedure sau:
--SP_Them_LoaiSP: Thêm mới một loại sản phẩm
create proc add_product_Type @type_id int,@type_name varchar(50)
as
begin
	insert into product_type
	values (@type_id,@type_name)
end
--SP_Them_NCTN: Thêm mới người chịu trách nhiệm
create proc add_reponsibility
    @resp_id int,
    @resp_name varchar(50)
as
begin
    INSERT INTO responsibility_person (resp_id, resp_name)
    VALUES (@resp_id, @resp_name)
end
--SP_Them_SanPham: Thêm mới một sản phẩm
CREATE PROCEDURE add_new_product
    @product_id varchar(50),
    @production_date date,
    @type_id varchar(50),
    @resp_id int
AS
BEGIN
    INSERT INTO products (product_id, production_date, type_id, resp_id)
    VALUES (@product_id, @production_date, @type_id, @resp_id)
END
--SP_Xoa_SanPham: Xóa một sản phẩm theo mã sản phẩm
CREATE PROCEDURE delete_product_by_id
    @product_id varchar(50)
AS
BEGIN
    DELETE FROM products
    WHERE product_id = @product_id
END
--SP_Xoa_SanPham_TheoLoai: Xóa các sản phẩm của một loại nào đó
CREATE PROCEDURE delete_product_by_type
    @type_id varchar(50)
AS
BEGIN
    DELETE FROM products
    WHERE type_id = @type_id
END






