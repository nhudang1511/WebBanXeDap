Create database ChoOnline
go

Use ChoOnline
Go



create table Style 
(
	_id int identity primary key,
	name nvarchar(32) unique not null,
	categoryId int references Category(_id) not null,
	image nvarchar(100),
	isDeleted bit default 0,
	createdAt date default getdate(),
	updatedAt date default getdate()
)
go

create table Style_Category
(
	StyleId int references Style(_id),
	CategoryId int references Category(_id),
	primary key(StyleId, CategoryId)
)
go

create trigger trg_UpdateStyle on Style
for update
as
begin
	declare @oldId int;
	declare @newId int;
	select @oldId = deleted._id, @newId = inserted._id
	from deleted, inserted
	update Style set updatedAt = getdate() where @oldId = @newId
end;
go

create table StyleValue
(
	_id int identity primary key,
	name nvarchar(32) unique not null,
	styleId int references Style(_id) not null,
	isDeleted bit default 0,
	createdAt date default getdate(),
	updatedAt date default getdate()
)
go

create trigger trg_UpdateStyleValue on StyleValue
for update
as
begin
	declare @oldId int;
	declare @newId int;
	select @oldId = deleted._id, @newId = inserted._id
	from deleted, inserted
	update StyleValue set updatedAt = getdate() where @oldId = @newId
end;
go

create table Product
(
	_id int identity primary key,
	name nvarchar(100) unique not null,
	slug nvarchar(110) unique,
	description nvarchar(1000) not null,
	price decimal not null,
	promotionalPrice decimal not null,
	quantity int not null,
	sold int not null default 0, 
	isActive bit default 1,
	isSelling bit default 1,
	categoryId int references Category(_id) not null,
	storeId int references Store(_id) not null,
	isDeleted bit default 0,
	rating int default 3,
	createdAt date default getdate(),
	updatedAt date default getdate()
	check(price > 0 and promotionalPrice > 0 and promotionalPrice < price and quantity > 0 and sold > 0 and rating > 0 and rating < 5)
)
go

create table ListImages
(
	_id int not null references Product(_id),
	image nvarchar(100)	
)
go

create table Product_Style
(
	StyleId int references Style(_id),
	ProductId int references Product(_id),
	primary key(StyleId, ProductId)
)
go

create trigger trg_UpdateInsertProduct on Product
for update, insert
as
begin
	declare @oldId int;
	declare @newId int;
	select @oldId = deleted._id, @newId = inserted._id
	from deleted, inserted
	update Product set updatedAt = getdate(), slug = 'SEO' + name where @oldId = @newId
end;
go

create table Delivery
(
	_id int identity primary key,
	name nvarchar(100) unique not null,
	description nvarchar(1000) not null,
	price decimal not null,
	isDeleted bit default 0,
	createdAt date default getdate(),
	updatedAt date default getdate()
	check(price > 0)
)
go

create trigger trg_UpdateDelivery on Delivery
for update
as
begin
	declare @oldId int;
	declare @newId int;
	select @oldId = deleted._id, @newId = inserted._id
	from deleted, inserted
	update Delivery set updatedAt = getdate() where @oldId = @newId
end;
go

create table UserFollowStore
(
	_id int identity primary key,
	userId int references _User(_id) not null,
	storeId int references Store(_id) not null,
	createdAt date default getdate(),
	updatedAt date default getdate()
)
go

create trigger trg_UpdateUserFollowStore on UserFollowStore
for update
as
begin
	declare @oldId int;
	declare @newId int;
	select @oldId = deleted._id, @newId = inserted._id
	from deleted, inserted
	update UserFollowStore set updatedAt = getdate() where @oldId = @newId
end;
go

create table UserFollowProduct
(
	_id int identity primary key,
	userId int references _User(_id) not null,
	productId int references Product(_id) not null,
	createdAt date default getdate(),
	updatedAt date default getdate()
)
go

create trigger trg_UpdateUserFollowProduct on UserFollowProduct
for update
as
begin
	declare @oldId int;
	declare @newId int;
	select @oldId = deleted._id, @newId = inserted._id
	from deleted, inserted
	update UserFollowProduct set updatedAt = getdate() where @oldId = @newId
end;
go


Create table Review(
  _id int IDENTITY(1,1) primary key, 
  userId int,
  productId int,
  storeId int,
  orderId int,
  content nvarchar(255),
  stars int,
  createdAt date,
  updatedAt date

)
Go

ALTER TABLE Review ADD CONSTRAINT fk_userId FOREIGN KEY (userId) REFERENCES _User(userId);
ALTER TABLE Review ADD CONSTRAINT fk_productId FOREIGN KEY (productId) REFERENCES Product(productId);
ALTER TABLE Review ADD CONSTRAINT fk_storeId FOREIGN KEY (storeId) REFERENCES Store(storeId);
ALTER TABLE Review ADD CONSTRAINT fk_orderId FOREIGN KEY (orderId) REFERENCES OrderItem(orderId);
Go

Create table OrderItem(
  _id int IDENTITY(1,1) primary key, 
  userId int,
  storeId int,
  deliveryId int,
  commissionId int,
  address nvarchar(255),
  phone int,
  status nvarchar(255),
  isPaidBefore bit,
  amountFromUser int,
  amountFromStore int,
  amountToStore int,
  amountToGD int,
  createdAt date,
  updatedAT date
)
Go

ALTER TABLE Order_SP ADD CONSTRAINT fk_userId FOREIGN KEY (userId) REFERENCES _User(userId);
ALTER TABLE Order_SP ADD CONSTRAINT fk_storeId FOREIGN KEY (storeId) REFERENCES Store(storeId);
ALTER TABLE Order_SP ADD CONSTRAINT fk_deliveryId FOREIGN KEY (deliveryId) REFERENCES Delivery(deliveryId);
ALTER TABLE Order_SP ADD CONSTRAINT fk_commissionId FOREIGN KEY (commissionId) REFERENCES Commission(commisionId);
Go


Create table OrderItem(
  _id int IDENTITY(1,1) primary key, 
  orderId int,
  productId int,
  styleValueIds int,
  count_SP int,
  createdAt date,
  updatedAT date
)
Go

ALTER TABLE OrderItem ADD CONSTRAINT fk_orderId FOREIGN KEY (orderId) REFERENCES OrderItem(orderId);
ALTER TABLE OrderItem ADD CONSTRAINT fk_productId FOREIGN KEY (productId) REFERENCES Product(productId);
ALTER TABLE OrderItem ADD CONSTRAINT fk_styleValueIds FOREIGN KEY (styleValueIds) REFERENCES StyleValue(styleValueIds);
Go

Create table Cart(
  _id int IDENTITY(1,1) primary key, 
  userId int,
  storetId int,
  createdAt date,
  updatedAT date
)
Go

ALTER TABLE Cart ADD CONSTRAINT fk_userId FOREIGN KEY (useId) REFERENCES _User(userId);
ALTER TABLE Cart ADD CONSTRAINT fk_storeId FOREIGN KEY (storeId) REFERENCES Store(storeId);
Go

Create table CartItem(
  _id int IDENTITY(1,1) primary key, 
  cartId int,
  productId int,
  styleValueIds int,
  count_SP int,
  createdAt date,
  updatedAT date
)
Go

ALTER TABLE CartItem ADD CONSTRAINT fk_cartId FOREIGN KEY (cartId) REFERENCES Cart(cartId);
ALTER TABLE CartItem ADD CONSTRAINT fk_productId FOREIGN KEY (productId) REFERENCES Product(productId);
ALTER TABLE CartItem ADD CONSTRAINT fk_styleValueIds FOREIGN KEY (styleValueIds) REFERENCES StyleValue(styleValueIds);
Go

Create table Transaction_SP(
  _id int IDENTITY(1,1) primary key, 
  userId int,
  storeId int,
  isUp bit,
  amount int,
  createdAt date,
  updatedAT date
)
Go

ALTER TABLE Transaction_SP ADD CONSTRAINT fk_userId FOREIGN KEY (userId) REFERENCES _User(userId);
ALTER TABLE Transaction_SP ADD CONSTRAINT fk_storeId FOREIGN KEY (storeId) REFERENCES Store(storeId);
Go


create table _User(
	_id int IDENTITY(1,1) primary key,
	firstname nvarchar(32) not null,
	lastname nvarchar(32) not null,
	slug nvarchar(100) unique,
	id_card varchar(50) unique,
	email varchar(100) unique,
	phone varchar(20) unique,
	isEmalActive bit default(0),
	isPhoneActive bit default(0),
	salt varchar(MAX),
	hashed_password varchar(MAX) not null,
	_role varchar(10) default('user'),
	addresses nvarchar(200),
	avatar nvarchar(500),
	cover nvarchar(500),
	point int default(0),
	e_wallet decimal(10,4) default(0),
	createdAt datetime default(getdate()),
	updatedAt datetime default(getdate())
)
---------------------------------------------
create table UserLevel(
	_id int identity(1,1) primary key,
	_name nvarchar(32) not null unique,
	minPoint int not null unique,
	discount decimal(4,2) not null,
	isDeleted bit default(0),
	createdAt datetime default(getdate()),
	updatedAt datetime default(getdate())
)
-----------------------------------------------
create table Store(
	_id int identity(1,1) primary key,
	_name nvarchar(100) not null unique,
	bio nvarchar(1000) not null,
	slug nvarchar(100) unique,
	ownerId int not null,
	staffIds nvarchar(500),
	isActive bit default(0),
	isOpen bit default(0),
	avatar nvarchar(500),
	cover nvarchar(500),
	featured_images nvarchar(500),
	commissionId int,
	point int default(0),
	rating int default(3),
	check(rating <= 5),
	e_wallet decimal(10,4) default(0),
	createdAt datetime default(getdate()),
	updatedAt datetime default(getdate())
)
-----------------------------------------------
Create table StoreLevel(
	_id int identity(1,1) primary key,
	_name nvarchar(32) not null unique,
	minPoint int not null unique,
	discount decimal(4,2) not null,
	isDeleted bit default(0),
	createdAt datetime default(getdate()),
	updatedAt datetime default(getdate())
)
------------------------------------------------
create table Commission(
	_id int identity(1,1) primary key,
	_name nvarchar(32) not null unique,
	cost decimal(10,4) not null unique,
	_description nvarchar(32) not null unique,
	isDeleted bit default(0),
	createdAt datetime default(getdate()),
	updatedAt datetime default(getdate())
)
---------------------------------------------
create table Category(
	_id int identity(1,1) primary key,
	_name nvarchar(32) not null unique,
	slug nvarchar(100) unique,
	categoryId int,
	_image nvarchar(500),
	isDeleted bit default(0),
	createdAt date default(getdate()),
	updatedAt date default(getdate())
)