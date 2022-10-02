create database sepet_vt
use sepet_vt

create table urun(
uno int primary key not null,
uadi nvarchar(20) not null,
fiyat money not null,
miktar int not null
)

create table musteri(
mno int primary key not null,
ad nvarchar(20) not null,
soyad nvarchar(20) not null,
dtarih date not null,
tc nvarchar(11) not null
)

create table musteriurun(
no int primary key identity(1,1),
mno int not null foreign key references musteri(mno),
uno int not null foreign key references urun(uno),
tarih datetime not null,
miktar int  not null
)

create trigger tr_sepetekle
on musteriurun
for insert 
as
begin
declare @uno int,@sayi int,@a int
select @uno=uno,@sayi = miktar from inserted
if (select miktar from urun where uno= @uno) >= (select miktar from musteriurun where uno = @uno) 
begin
	update urun set miktar = miktar - @sayi where uno=@uno
end
else if((select miktar from urun where uno= @uno)=0)
	begin
		set @a = 0
		exec kontrol @a
	end
 else
	begin
		
	end
end


create trigger tr_spetguncelle
on musteriurun
for update
as
begin
	declare @esayi int , @ysayi int ,@uno int
	select @esayi = miktar ,@uno=uno from deleted
	select @ysayi = miktar from inserted

	if (select miktar from urun where uno= @uno) >= (select miktar from inserted where uno = @uno)
	begin
	update urun set miktar = miktar+@esayi where uno = @uno
	update urun set miktar = miktar-@ysayi where uno = @uno
	end
	else 
	print 'Yetersiz Stok'
end
create trigger tr_sepetsil
on musteriurun
for delete
as begin
declare @sayi int, @uno int
select @sayi = miktar,@uno = uno from deleted
update urun set miktar = miktar + @sayi where uno=@uno
end

