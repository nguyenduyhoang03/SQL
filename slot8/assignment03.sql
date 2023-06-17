--2
--bảng khách hàng
create table customers(
	customer_id int primary key,
	customer_name varchar(50) not null,
	identification_number int not null,
	address varchar(100) not null
)
--bảng số thuê bao
create table subscriptions(
	subscription_id int primary key,
	customer_id int,
	foreign key (customer_id) references customers(customer_id),
	subscription_type varchar(50) not null,
	registration_date date not null
)
--3) Viết các câu lệnh để thêm dữ liệu vào các bảng
insert into customers (customer_id,customer_name,identification_number,address)
values (01,'Nguyễn Nguyệt Nga',123456789,'Hà Nội')
insert into subscriptions (subscription_id,customer_id,subscription_type,registration_date)
values(123456789,01,'Trả trước',2002-12-12)
--4)Viết các câu lênh truy vấn để
--a) Hiển thị toàn bộ thông tin của các khách hàng của công ty
select * from customers
--b) Hiển thị toàn bộ thông tin của các số thuê bao của công ty
select * from subscriptions
--5)Viết các câu lệnh truy vấn để lấy
--a) Hiển thị toàn bộ thông tin của thuê bao có số: 0123456789
select c.customer_id,c.customer_name,c.identification_number,c.address,
s.subscription_id,s.subscription_type,s.registration_date
from customers c
join subscriptions s ON s.customer_id = c.customer_id
where s.subscription_id = '0123456789';
--b) Hiển thị thông tin về khách hàng có số CMTND: 123456789select * from customers 
where identification_number = '123456789'
--c) Hiển thị các số thuê bao của khách hàng có số CMTND:123456789
select * from subscriptions s
join customers c ON c.customer_id = s.customer_id
where c.identification_number = '123456789'
--d) Liệt kê các thuê bao đăng ký vào ngày 12/12/09
select c.customer_name,s.subscription_id,s.registration_date
from subscriptions s
join customers c ON c.customer_id = s.customer_id
where s.registration_date = '2009-12-12';
--e) Liệt kê các thuê bao có địa chỉ tại Hà Nội
select s.subscription_id from subscriptions s
join customers c ON c.customer_id = s.customer_id
where c.address = 'Hà Nội';
--6. Viết các câu lệnh truy vấn để lấy
--a) Tổng số khách hàng của công ty.
select count(customer_id) from customers
--b)Tổng số thuê bao của công ty
select count(subscription_id) from subscriptions
--c) Tổng số thuê bào đăng ký ngày 12/12/09
select count(subscription_id) from subscriptions
where registration_date = '2009-12-12'
--d) Hiển thị toàn bộ thông tin về khách hàng và thuê bao của tất cả các số thuê bao.
SELECT c.customer_name, c.identification_number, c.Address, s.subscription_id, s.subscription_type, s.registration_date
FROM Customers c
JOIN Subscriptions s ON c.customer_id = s.customer_id;
--7. Thay đổi những thay đổi sau trên cơ sở dữ liệu
--a) Viết câu lệnh để thay đổi trường ngày đăng ký là not null.
alter table subsciptions
alter column registration_date date not null
--b) Viết câu lệnh để thay đổi trường ngày đăng ký là trước hoặc bằng ngày hiện tại.
UPDATE Subscriptions
SET registration_date = GETDATE()
WHERE registration_date > GETDATE();
--c) Viết câu lệnh để thay đổi số điện thoại phải bắt đầu 09
update subscriptions
set subscription_id = '09' + SUBSTRING(subscription_id,1,len(subscription_id))
where subscription_id not like '09%'
--d) Viết câu lệnh để thêm trường số điểm thưởng cho mỗi số thuê bao.
alter table subsciption
add Point_Gift int
--8. Thực hiện các yêu cầu sau
--a) Đặt chỉ mục (Index) cho cột Tên khách hàng của bảng chứa thông tin khách hàng
create index idx_customer on customers(customer_name)
--b) Viết các View sau:
--View_KhachHang: Hiển thị các thông tin Mã khách hàng, Tên khách hàng, địa chỉ
create view cus_view as
select customer_id,customer_name,address
from customers
--View_KhachHang_ThueBao: Hiển thị thông tin Mã khách hàng, Tên khách hàng, Số thuê bao
create view cus_subscription as
select c.customer_id,c.customer_name,s.subscription_id
from customers c
join subscriptions s ON s.customer_id = c.customer_id
--c) Viết các Store Procedure sau:
-- SP_TimKH_ThueBao: Hiển thị thông tin của khách hàng với số thuê bao nhập vào
create procedure searchByNumber @number int
as
begin
	select c.customer_name,c.identification_number,c.address,
	s.subscription_id,s.subscription_type,s.registration_date from customers c
	join subscriptions s ON s.customer_id = c.customer_id
	where @number = s.subscription_id
end
--SP_TimTB_KhachHang: Liệt kê các số điện thoại của khách hàng theo tên truyền vào
create procedure SearchByName @name varchar(50)
as
begin
	select s.subscription_id from subscriptions s
	join customers c ON s.customer_id = c.customer_id
	where @name = c.customer_name
end
-- SP_ThemTB: Thêm mới một thuê bao cho khách hàngcreate procedure add_PhoneNumber @phoneNumber int,@customer_id int,
@subscription_type varchar(50),@subscription_date date
as
begin
 IF EXISTS (SELECT * FROM Customers WHERE customer_id = @customer_id)
   BEGIN
	insert into subscriptions (subscription_id,customer_id,subscription_type,registration_date)
	values(@phoneNumber,@customer_id,@subscription_type,@subscription_date)
	SELECT 'Thêm mới thuê bao thành công' AS Result
   end
   else
   begin
	SELECT 'Khách hàng không tồn tại' AS Result
   end
end
--SP_HuyTB_MaKH: Xóa bỏ thuê bao của khách hàng theo Mã khách hàngcreate procedure deleteCusById @customer_id int 
as 
begin
	if exists (select * from customers where @customer_id = customer_id)
	begin
		delete from subscriptions where @customer_id = customer_id
		select 'Xóa thuê bao thành công' AS result
	end
	else
	begin
		select 'Không tồn tại' AS result
	end
end