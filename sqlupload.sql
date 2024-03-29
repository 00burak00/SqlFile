USE [ertevproje]
GO
/****** Object:  Table [dbo].[Egitim]    Script Date: 26.09.2022 23:37:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Egitim](
	[tur] [nvarchar](50) NOT NULL,
	[adi] [nvarchar](50) NOT NULL,
	[tarih] [date] NOT NULL,
	[ogrencisay] [int] NOT NULL,
	[icerik] [nvarchar](50) NOT NULL,
	[egitimkod] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Egitim] PRIMARY KEY CLUSTERED 
(
	[egitimkod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Egitim] ([tur], [adi], [tarih], [ogrencisay], [icerik], [egitimkod]) VALUES (N'aa3', N'aa3', CAST(N'1995-05-05' AS Date), 45, N'aa33', N'ab3')
GO
