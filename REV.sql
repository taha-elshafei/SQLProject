
select * from country

select UPPER( SUBSTRING( [countryname],1,1)) + lower( SUBSTRING( [countryname],2,len([countryname]))) from country 
delete from [dbo].[country]
where id not in (
select  min(id) CountOfCountry from [dbo].[country] 
group by [countryname])


alter view V_AllDataOfCountry 
as
select [districtname],[cityname],[countryname]from [dbo].[country] join [dbo].[city] 
on country.id = city.country_id
join [dbo].[district] 
on city.id = district.city_id

select * from V_AllDataOfCountry

SP_AllDataaa 

alter proc SP_AllDataaa 
@actiontype tinyint = 1,
@id tinyint = 1,
@countryName nvarchar(50)
as
if @actiontype = 1
begin
select *from [dbo].[country]
end
if @actiontype = 2
begin
select *from [dbo].[country]where id = @id
end
if @actiontype = 3
begin
insert into [dbo].[country] ([countryname])values (@countryName) 
end
if @actiontype = 4
begin
update [dbo].[country] set [countryname] = @countryName where id =@id
end
if @actiontype = 5
begin
delete from [dbo].[country] where id = @id
end

create trigger T_AllDataInsert on [dbo].[country]
after insert 
as 
insert into [dbo].[Audit_Country]([countryId],[countryname],[actiontype]) 
select [id],[countryname],'insert' from inserted









