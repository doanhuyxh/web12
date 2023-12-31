USE [PhucThanh_Ecomerce]
GO
/****** Object:  StoredProcedure [dbo].[ptgroupOrder_ListAllPaging]    Script Date: 4/19/2017 10:37:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Auto Generator
-- Create date: 12/14/2016
-- Description:	The procedure select all record with paging for Orders table.
-- =============================================
ALTER procedure [dbo].[ptgroupOrder_ListAllPaging]

(
@dateFrom datetime = null,
@dateTo datetime = null,
@Status int,
@OrderCode bigint,
@pageIndex int,
@pageSize int,
@totalRow int output
)

as

set nocount on

DECLARE @UpperBand int, @LowerBand int

SELECT @totalRow = COUNT(*) FROM Orders where (@dateFrom is null or (@dateFrom is not null and CONVERT(date, OrderDate) >= CONVERT(date, @dateFrom)))
										and (@dateTo is null or (@dateTo is not null and CONVERT(date, OrderDate) <= CONVERT(date, @dateTo)))
										and (@OrderCode = 0 or (@OrderCode <> 0 and OrderCode = @OrderCode))
										and (@Status = 0 or (@Status <> 0 and Status = @Status))

SET @LowerBand  = (@pageIndex - 1) * @PageSize
SET @UpperBand  = (@pageIndex * @PageSize)

SELECT  [Id],
    [OrderCode],
	[CustomerId],
	[OrderDate],
	[Status],
	[TotalPrice],
	CustomerName,
	[Address]
 FROM(SELECT  o.Id,o.CustomerId, o.OrderDate, o.[Status],o.[OrderCode],(select Sum(UnitPrice) from OrderDetails where OrderId = o.Id) as TotalPrice, ar.FullName CustomerName, ar.[Address],
 ROW_NUMBER() OVER(ORDER BY o.Id DESC) AS RowNumber FROM Orders o WITH (NOLOCK)
 LEFT JOIN Address_Received ar ON o.Id = ar.OrderId
 where (@dateFrom is null or (@dateFrom is not null and convert(date, OrderDate) >= convert(date, @dateFrom) ))
		and (@dateTo is null or (@dateTo is not null and CONVERT(date,OrderDate) <= CONVERT(date,@dateTo)))
		and (@OrderCode = 0 or (@OrderCode <> 0 and OrderCode = @OrderCode))
		and (@Status = 0 or (@Status <> 0 and Status = @Status))
 ) AS temp
WHERE RowNumber > @LowerBand AND RowNumber <= @UpperBand

