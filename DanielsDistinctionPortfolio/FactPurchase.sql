SELECT
	p.PurchaseID,
	pri.PurchaseItemID,
	dimd.Date_SK AS PurchaseDate,
	dimc.Customer_SK,
	dims.Shopper_SK,
	dimi.Item_SK,
	dime.EventType_SK,
	i.Price AS ItemPrice,
	i.Cost AS ItemCost,
	i.Price - i.Cost AS ItemProfit,
	pri.Quantity,
	i.Price * pri.Quantity AS Revenue,
	i.Cost * pri.Quantity AS Cost,
	(i.Price * pri.Quantity) - i.Cost * pri.Quantity AS Profit
FROM
	SilhouetteCollective.dbo.PurchaseItem pri
LEFT JOIN
	SilhouetteCollective.dbo.Purchase p
ON
	pri.PurchaseID = p.PurchaseID
LEFT JOIN	
	SilhouetteCollective.dbo.Item i
ON
	pri.ItemID = i.ItemID
LEFT JOIN
	SilhouetteCollectiveDM.dbo.DimCustomer dimc
ON
	dimc.Customer_BK = p.CustomerID
LEFT JOIN
	SilhouetteCollectiveDM.dbo.DimShopper dims
ON
	dims.Shopper_BK = p.ShopperID
LEFT JOIN
	SilhouetteCollectiveDM.dbo.DimItem dimi
ON
	dimi.Item_BK = pri.ItemID
LEFT JOIN
	SilhouetteCollectiveDM.dbo.DimEventType dime
ON
	dime.EventType_BK = p.EventTypeID
LEFT JOIN
	SilhouetteCollectiveDM.dbo.DimDate dimd
ON
	dimd.[Date] = p.PurchaseDate;