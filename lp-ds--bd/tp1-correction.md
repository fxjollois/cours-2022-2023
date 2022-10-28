class: middle, center, inverse, title
# Correction du TP 1

---
## 1- Compter le nombre de clients

```sas
proc sql;
	title 1- Compter le nombre de clients;
	SELECT COUNT (*) FROM DimCustomer;
quit;
```

---
## 2- Compter le nombre de pays d’origine des clients

```sas
proc sql;
	title 2- Compter le nombre de pays d’origine des clients;
	SELECT COUNT (DISTINCT EnglishCountryRegionName) 
		FROM DimCustomer INNER JOIN DimGeography ON DimCustomer.GeographyKey = DimGeography.GeographyKey;
quit;
```

---
## 3- Donner par catégorie, le nombre de produits et le nombre de sous-catégories

```sas
proc sql;
	title 3- Donner par catégorie, le nombre de produits et le nombre de sous-catégories;
	SELECT EnglishProductCategoryName, 
			COUNT (*) AS NbProduits,
			COUNT (DISTINCT DimProductSubcategory.ProductSubcategoryKey) AS NbSousCategories
		FROM DimProduct, DimProductSubcategory, DimProductCategory
		WHERE DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
		AND   DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey
		GROUP BY EnglishProductCategoryName
		ORDER BY 2 DESC;
quit;
```

---
## 4- Donner les 10 produits les plus vendus

```sas
proc sql OUTOBS=10;
	title 4a- Donner les 10 produits les plus vendus;
	title2 Sur le nombre de ventes;
	SELECT DimProduct.ProductKey, EnglishProductName, FrenchProductName, COUNT (*) AS NbVentes
		FROM DimProduct, FactInternetSales
		WHERE DimProduct.ProductKey = FactInternetSales.ProductKey
		GROUP BY DimProduct.ProductKey, EnglishProductName, FrenchProductName
		ORDER BY NbVentes DESC;

	title 4b- Donner les 10 produits les plus vendus;
	title2 Sur le montant total des ventes;
	SELECT DimProduct.ProductKey, EnglishProductName, FrenchProductName, SUM (ExtendedAmount) AS MontantVentes
		FROM DimProduct, FactInternetSales
		WHERE DimProduct.ProductKey = FactInternetSales.ProductKey
		GROUP BY DimProduct.ProductKey, EnglishProductName, FrenchProductName
		ORDER BY MontantVentes DESC;
quit;
```

---
## 5- Calculer le montant total du CA

```sas
proc sql;
	title 5- Calculer le montant total du CA;
	SELECT SUM(ExtendedAmount) AS CA format=dollar12.2 FROM FactInternetSales;
quit;
```

---
## 6- Donner les 10 clients ayant le CA le plus élevé

```sas
proc sql outobs=10;
	title 6- Donner les 10 clients ayant le CA le plus élevé;
	SELECT DimCustomer.CustomerKey, FirstName, LastName, SUM(ExtendedAmount) AS CA
		FROM DimCustomer, FactInternetSales
		WHERE DimCustomer.CustomerKey = FactInternetSales.CustomerKey
		GROUP BY DimCustomer.CustomerKey, FirstName, LastName
		ORDER BY CA DESC;
quit;
```

---
## 7- Calculer le CA par année (en considérant la date de commande)

```sas
proc sql;
	title 7- Calculer le CA par année (en considérant la date de commande);
	SELECT CalendarYear, SUM(ExtendedAmount) AS CA format=dollar12.2 
		FROM DimDate, FactInternetSales
		WHERE DimDate.DateKey = FactInternetSales.OrderDateKey
		GROUP BY CalendarYear;
quit;
```

---
## 8- Idem, mais par mois

```sas
proc sql;
	title 8- Idem, mais par mois;
	SELECT MonthNumberOfYear, EnglishMonthName, SUM(ExtendedAmount) AS CA format=dollar12.2 
		FROM DimDate, FactInternetSales
		WHERE DimDate.DateKey = FactInternetSales.OrderDateKey
		GROUP BY MonthNumberOfYear, EnglishMonthName
		ORDER BY MonthNumberOfYear;
quit;
```

---
## 9- Idem, mais par jour de la semaine

```sas
proc sql;
	title 9- Idem, mais par jour de la semaine;
	SELECT DayNumberOfWeek, EnglishDayNameOfWeek, SUM(ExtendedAmount) AS CA format=dollar12.2 
		FROM DimDate, FactInternetSales
		WHERE DimDate.DateKey = FactInternetSales.OrderDateKey
		GROUP BY DayNumberOfWeek, EnglishDayNameOfWeek
		ORDER BY DayNumberOfWeek;
quit;
```

---
## 10- Idem, mais par jour sur toute la période

```sas
proc sql;
	title 10- Idem, mais par jour sur toute la période;
CREATE VIEW CA_jour AS
	SELECT FullDateAlternateKey, SUM(ExtendedAmount) AS CA format=dollar12.2 
		FROM DimDate, FactInternetSales
		WHERE DimDate.DateKey = FactInternetSales.OrderDateKey
		GROUP BY FullDateAlternateKey
		ORDER BY FullDateAlternateKey;
quit;

symbol1 interpol=join; 
PROC GPLOT DATA = CA_jour;
	plot CA * FullDateAlternateKey;
RUN;
QUIT;
```

---
## 11- Calculer le nombre de ventes pour chaque catégorie de produit et pour chaque jour de la semaine

```sas
proc sql;
	title 11- Calculer le nombre de ventes pour chaque catégorie de produit et pour chaque jour de la semaine;
	SELECT EnglishProductCategoryName, FrenchDayNameOfWeek, COUNT(*) AS NbVentes
		FROM DimProductCategory, DimProductSubcategory, DimProduct, FactInternetSales, DimDate
		WHERE DimProductCategory.ProductCategoryKey = DimProductSubcategory.ProductCategoryKey
		AND DimProductSubcategory.ProductSubcategoryKey = DimProduct.ProductSubcategoryKey
		AND DimProduct.ProductKey = FactInternetSales.ProductKey
		AND FactInternetSales.OrderDateKey = DimDate.DateKey
		GROUP BY EnglishProductCategoryName, DayNumberOfWeek, FrenchDayNameOfWeek
		ORDER BY EnglishProductCategoryName, DayNumberOfWeek;
quit;
```

---
## 12- Calculer le CA pour chaque catégorie de produit et pour chaque pays du client

```sas
proc sql;
	title 12- Calculer le CA pour chaque catégorie de produit et pour chaque pays du client;
	SELECT EnglishProductCategoryName, EnglishCountryRegionName, COUNT(*) AS NbVentes
		FROM DimProductCategory, DimProductSubcategory, DimProduct, FactInternetSales, DimCustomer, DimGeography
		WHERE DimProductCategory.ProductCategoryKey = DimProductSubcategory.ProductCategoryKey
		AND DimProductSubcategory.ProductSubcategoryKey = DimProduct.ProductSubcategoryKey
		AND DimProduct.ProductKey = FactInternetSales.ProductKey
		AND FactInternetSales.CustomerKey = DimCustomer.CustomerKey
		AND DimCustomer.GeographyKey = DimGeography.GeographyKey
		GROUP BY EnglishProductCategoryName, EnglishCountryRegionName
		ORDER BY EnglishProductCategoryName, EnglishCountryRegionName;
quit;
```

---
## 13- Calculer le CA pour chaque catégorie pour chaque année pour chaque pays de vente pour chaque promotion

```sas
proc sql;
	title 13- Calculer le CA pour chaque catégorie pour chaque année pour chaque pays de vente pour chaque promotion;
	SELECT EnglishProductCategoryName, CalendarYear, EnglishCountryRegionName, EnglishPromotionName,
				COUNT(*) AS NbVentes
		FROM DimProductCategory, DimProductSubcategory, DimProduct, 
			FactInternetSales, DimDate, DimCustomer, DimGeography,
			DimPromotion
		WHERE DimProductCategory.ProductCategoryKey = DimProductSubcategory.ProductCategoryKey
		AND DimProductSubcategory.ProductSubcategoryKey = DimProduct.ProductSubcategoryKey
		AND DimProduct.ProductKey = FactInternetSales.ProductKey
		AND FactInternetSales.OrderDateKey = DimDate.DateKey
		AND FactInternetSales.PromotionKey = DimPromotion.PromotionKey
		AND FactInternetSales.CustomerKey = DimCustomer.CustomerKey
		AND DimCustomer.GeographyKey = DimGeography.GeographyKey
		GROUP BY EnglishProductCategoryName, CalendarYear, EnglishCountryRegionName, EnglishPromotionName
		ORDER BY EnglishProductCategoryName, CalendarYear, EnglishCountryRegionName, EnglishPromotionName;
quit;
```

---
## 14- Existe-t'il des clients ayant acheté des produits dans chaque catégorie ? si oui lesquels ?

### Version longue avec `EXISTS`

```sas
proc sql;
	title1 14- Existe-t''il des clients ayant acheté des produits dans chaque catégorie ? si oui lesquels ?;
	title2 VERSION LONGUE A EXECUTER;
	SELECT FirstName, LastName
		FROM DimCustomer 
		WHERE NOT EXISTS 
			(SELECT *
				FROM DimProductCategory
				WHERE ProductCategoryKey NOT IN
					(SELECT ProductCategoryKey 
						FROM DimProductSubcategory, DimProduct, FactInternetSales
						WHERE DimProductSubcategory.ProductSubcategoryKey = DimProduct.ProductSubcategoryKey
						AND DimProduct.ProductKey = FactInternetSales.ProductKey
						AND FactInternetSales.CustomerKey = DimCustomer.CustomerKey));
quit;
```

---
## 14- Existe-t'il des clients ayant acheté des produits dans chaque catégorie ? si oui lesquels ?

### Version courte avec une petite astuce

```sas
proc sql;
	title 14- Existe-t''il des clients ayant acheté des produits dans chaque catégorie ? si oui lesquels ?;
	SELECT DimCustomer.CustomerKey, FirstName, LastName, COUNT(DISTINCT ProductCategoryKey)
		FROM DimCustomer, FactInternetSales, DimProduct, DimProductSubcategory
		WHERE DimCustomer.CustomerKey = FactInternetSales.CustomerKey
		AND FactInternetSales.ProductKey = DimProduct.ProductKey
		AND DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
		GROUP BY DimCustomer.CustomerKey, FirstName, LastName
		HAVING COUNT(DISTINCT ProductCategoryKey) = SELECT COUNT(*) FROM DimProductCategory
		ORDER BY 4 DESC;
quit;
```

---
## 15- Existe-t'il une promotion ayant fonctionné dans chaque pays ? si oui lesquelles ?

```sas
proc sql;
	title 15- Existe-t''il une promotion ayant fonctionné dans chaque pays ? si oui lesquelles ?;
	SELECT EnglishPromotionName, COUNT(DISTINCT EnglishCountryRegionName)
		FROM DimPromotion, FactInternetSales, DimCustomer, DimGeography
		WHERE DimPromotion.PromotionKey = FactInternetSales.PromotionKey
		AND FactInternetSales.CustomerKey = DimCustomer.CustomerKey
		AND DimCustomer.GeographyKey = DimGeography.GeographyKey
		GROUP BY EnglishPromotionName
		HAVING COUNT(DISTINCT EnglishCountryRegionName) = 
			SELECT COUNT(DISTINCT EnglishCountryRegionName) FROM DimGeography;
quit;
```

---
## 16- Lien entre pays et catégorie

```sas
proc sql;
	title 16- Lien entre pays et catégorie;
CREATE TABLE temp AS
	SELECT EnglishCountryRegionName, EnglishProductCategoryName, SUM(ExtendedAmount) AS CA
		FROM DimGeography, DimCustomer, FactInternetSales, 
			 DimProduct, DimProductSubCategory,DimProductCategory
		WHERE DimGeography.GeographyKey = DimCustomer.GeographyKey
		AND	  DimCustomer.CustomerKey = FactInternetSales.CustomerKey
		AND   FactInternetSales.ProductKey = DimProduct.ProductKey
		AND   DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
		AND   DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey
		GROUP BY EnglishCountryRegionName, EnglishProductCategoryName
		ORDER BY EnglishCountryRegionName, EnglishProductCategoryName;
quit;
PROC TRANSPOSE DATA = temp;
	VAR CA;
	ID EnglishProductCategoryName;
	BY EnglishCountryRegionName;
PROC PRINT;
RUN;
```
