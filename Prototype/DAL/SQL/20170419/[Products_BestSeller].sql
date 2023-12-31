USE [PhucThanh_Ecomerce]
GO
/****** Object:  StoredProcedure [dbo].[Products_BestSeller]    Script Date: 4/19/2017 11:08:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[Products_BestSeller] 
@cateId int = 0
as

set nocount on

/*select top sell*/
select top 4 p.Id,p.MakerId,p.ProductName,p.ProductCode,p.SellPrice,p.ListedPrice, 
dbo.func_GetPicture(p.PictureId,0) as PicturePath,pc.CateID as CateId
FROM (SELECT ProductId, COUNT(*) AS cnt
					  FROM [OrderDetails]
					 GROUP BY ProductId
					HAVING 1 <= ALL ( SELECT COUNT(*) 
									   FROM [OrderDetails]
									  GROUP BY ProductId)) as tmpTable left join [Products] p on p.Id = tmpTable.ProductId
																	   inner join ProductCate pc on p.Id = pc.ProductID
					where  p.IsDel = 0 and (@cateId = 0 or (@cateId > 0 and pc.CateId = @cateId))



