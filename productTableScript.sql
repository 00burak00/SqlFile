USE [sepet_vt]
GO
/****** Object:  Table [dbo].[musteri]    Script Date: 22.09.2022 08:15:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[musteri](
	[mno] [int] NOT NULL,
	[ad] [nvarchar](20) NOT NULL,
	[soyad] [nvarchar](20) NOT NULL,
	[dtarih] [date] NOT NULL,
	[tc] [nvarchar](11) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[mno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[musteriurun]    Script Date: 22.09.2022 08:15:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[musteriurun](
	[no] [int] NOT NULL,
	[mno] [int] NOT NULL,
	[uno] [int] NOT NULL,
	[tarih] [datetime] NOT NULL,
	[miktar] [int] NOT NULL,
 CONSTRAINT [PK__musteriu__3213D080E12C267E] PRIMARY KEY CLUSTERED 
(
	[no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[urun]    Script Date: 22.09.2022 08:15:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[urun](
	[uno] [int] NOT NULL,
	[uadi] [nvarchar](20) NOT NULL,
	[fiyat] [money] NOT NULL,
	[miktar] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[uno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[musteri] ([mno], [ad], [soyad], [dtarih], [tc]) VALUES (2, N'muro', N'kara', CAST(N'1911-05-16' AS Date), N'17525555')
GO
INSERT [dbo].[musteriurun] ([no], [mno], [uno], [tarih], [miktar]) VALUES (1, 2, 1, CAST(N'1975-06-06T00:00:00.000' AS DateTime), 100)
GO
INSERT [dbo].[urun] ([uno], [uadi], [fiyat], [miktar]) VALUES (1, N'pc', 12500.0000, 50)
INSERT [dbo].[urun] ([uno], [uadi], [fiyat], [miktar]) VALUES (2, N'laptop', 22500.0000, 500)
INSERT [dbo].[urun] ([uno], [uadi], [fiyat], [miktar]) VALUES (3, N'telefon', 7500.0000, 500)
INSERT [dbo].[urun] ([uno], [uadi], [fiyat], [miktar]) VALUES (52, N'traktor', 120000.0000, 0)
INSERT [dbo].[urun] ([uno], [uadi], [fiyat], [miktar]) VALUES (53, N'aa', 27000.0000, 0)
INSERT [dbo].[urun] ([uno], [uadi], [fiyat], [miktar]) VALUES (566, N'kapak', 1.0000, 100000)
GO
ALTER TABLE [dbo].[musteriurun]  WITH CHECK ADD  CONSTRAINT [FK__musteriurun__mno__286302EC] FOREIGN KEY([mno])
REFERENCES [dbo].[musteri] ([mno])
GO
ALTER TABLE [dbo].[musteriurun] CHECK CONSTRAINT [FK__musteriurun__mno__286302EC]
GO
ALTER TABLE [dbo].[musteriurun]  WITH CHECK ADD  CONSTRAINT [FK__musteriurun__uno__29572725] FOREIGN KEY([uno])
REFERENCES [dbo].[urun] ([uno])
GO
ALTER TABLE [dbo].[musteriurun] CHECK CONSTRAINT [FK__musteriurun__uno__29572725]
GO
/****** Object:  StoredProcedure [dbo].[kontrol]    Script Date: 22.09.2022 08:15:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[kontrol] @a int
as
begin
return @a
end
GO
/****** Object:  Trigger [dbo].[tr_sepetekle]    Script Date: 22.09.2022 08:15:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[tr_sepetekle]
on [dbo].[musteriurun]
for insert 
as
begin
declare @uno int,@sayi int
select @uno=uno,@sayi = miktar from inserted
if (select miktar from urun where uno= @uno) >= (select miktar from musteriurun where uno = @uno) 
begin
	update urun set miktar = miktar - @sayi where uno=@uno
end
else if((select miktar from urun where uno= @uno)=0)
	begin
		print 'elimizde bu üründen hiç bulunmamaktadır'
	end
 else
	begin
		print 'elimizde yeterli stok yok'
	end
end
GO
ALTER TABLE [dbo].[musteriurun] ENABLE TRIGGER [tr_sepetekle]
GO
/****** Object:  Trigger [dbo].[tr_sepetsil]    Script Date: 22.09.2022 08:15:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[tr_sepetsil]
on [dbo].[musteriurun]
for delete
as begin
declare @sayi int, @uno int
select @sayi = miktar,@uno = uno from deleted

update urun set miktar = miktar + @sayi where uno=@uno
end
GO
ALTER TABLE [dbo].[musteriurun] ENABLE TRIGGER [tr_sepetsil]
GO
/****** Object:  Trigger [dbo].[tr_spetguncelle]    Script Date: 22.09.2022 08:15:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[tr_spetguncelle]
on [dbo].[musteriurun]
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
GO
ALTER TABLE [dbo].[musteriurun] ENABLE TRIGGER [tr_spetguncelle]
GO
