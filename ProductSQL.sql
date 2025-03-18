



CREATE TABLE category (
    id INT PRIMARY KEY ,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE product (
    id INT PRIMARY KEY ,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    stock bit NOT NULL ,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES category(id) ON DELETE SET NULL
);
  


		INSERT INTO category (name) VALUES
('Electronics'),
('Clothing'),
('Furniture');

INSERT INTO product (name, price, quantity, stock, category_id) VALUES
('Smartphone', 3500.00, 10, 1, 1),
('Laptop', 12000.00, 5, 1, 1),
('Cotton Shirt', 250.00, 20, 1, 2),
('Leather Jacket', 850.00, 0, 0, 2),
('Wooden Table', 1500.00, 7, 1, 3),
('Comfortable Chair', 750.00, 3, 1, 3);


select * from product

INSERT INTO category (name) VALUES
('Appliances'),
('Books'),
('Toys');

INSERT INTO product (name, price, quantity, stock, category_id) VALUES
('Refrigerator', 8500.00, 4, 1, 4),
('Washing Machine', 6200.00, 2, 1, 4),
('Microwave Oven', 1500.00, 0, 0, 4),
('Science Fiction Book', 120.00, 30, 1, 5),
('History Book', 95.00, 15, 1, 5),
('Puzzle Game', 300.00, 8, 1, 6),
('Remote Control Car', 600.00, 5, 1, 6),
('Doll Set', 450.00, 0, 0, 6);

select [id],[name],[price],[quantity],
case  [stock]
when 1 then 'true'
when 0 then 'false '
end stockstatus
from [dbo].[product]
	

	select [dbo].[product].id,[dbo].[product].productname, [dbo].[category].categoryname,[price], [quantity] from [dbo].[product] join [dbo].[category]
	on [dbo].[product].category_id = [dbo].[category].id
	




	CREATE TABLE category_audit (
    audit_id INT PRIMARY KEY,
    category_id INT,
    name VARCHAR(255) NOT NULL,
    action_type nchar(10),
    action_time datetime2(7)
);
CREATE TABLE product_audit (
    audit_id INT PRIMARY KEY ,
    product_id INT,
    proname VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    stock BIT NOT NULL,
    category_id INT,
    action_type nchar(10),
    action_time datetime2(7)
);

SP_ProductGetAllData  

create proc SP_ProductGetAllData
@actiontype tinyint = 1,
@id smallint =1 , @productname nvarchar(255)='' ,
@price decimal(10,2)=0 , @quantity smallint = 0 ,@stock bit = 0
as
if @actiontype = 1
begin 
select * from [dbo].[product]
end
if @actiontype = 2
begin 
select * from [dbo].[product] where id= @id
end
if @actiontype = 3
begin 
insert into  [dbo].[product] ([productname],[price],[quantity],[stock])
values (@productname , @price , @quantity , @stock)
end
if @actiontype = 4
begin
UPDATE [dbo].[product]
SET[productname]= @productname , price = @price, quantity =@quantity, stock = @stock
WHERE id = id;
end
if @actiontype = 5
begin
delete from [dbo].[product] where id = @id
end



create trigger T_Insertproduct on [dbo].[product]
after insert
as
insert into [dbo].[product_audit] ([product_id],[proname],[price],[quantity],[action_type],[stock])
values (
(select [id] from inserted),(select [productname] from inserted) , (select [price] from inserted),
(select[quantity] from inserted ) , 'insert',(select[stock] from inserted )
)


create trigger T_Deleteproduct on [dbo].[product]
after delete
as
insert into [dbo].[product_audit] ([product_id],[proname],[price],[quantity],[stock],[category_id],[action_type])
values (
(select [id] from deleted),(select [productname] from deleted) , (select [price] from deleted),
(select[quantity] from deleted ) , (select[stock] from deleted ),(select [category_id]from deleted ),'delete'
)

CREATE TRIGGER T_DeleteProductt 
ON [dbo].[product]
AFTER update 
AS
BEGIN
    INSERT INTO [dbo].[product_audit] 
    ([product_id], [proname], [price], [quantity], [stock], [category_id], [action_type])
    SELECT 
        id, productname, price, quantity, stock, category_id, 'DELETE'
    FROM deleted;
END;


CREATE TRIGGER T_UpdateProduct 
ON [dbo].[product]
AFTER UPDATE
AS
    INSERT INTO [dbo].[product_audit] 
    ([product_id], [proname], [price], [quantity], [stock], [category_id], [action_type])
    SELECT 
        id, productname, price, quantity, stock, category_id, 'UPDATE'
    FROM inserted;










