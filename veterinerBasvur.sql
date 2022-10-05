use veterinerBasvur
alter procedure listeleme
as
begin
select ad,soyad,tel from Basvuru where  id = (select COUNT (*) from Basvuru )
end

create trigger liste
on Basvuru
for insert 
as
begin

exec listeleme

end
