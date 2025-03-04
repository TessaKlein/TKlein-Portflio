SELECT
	ItemID AS Item_BK,
	Item,
	Color,
	Brand
FROM
	SilhouetteCollective.dbo.Item i
LEFT JOIN
	SilhouetteCollective.dbo.Color c
ON
	i.ColorID = c.ColorID
LEFT JOIN
	SilhouetteCollective.dbo.Brand b
ON
	i.BrandID = b.BrandID;