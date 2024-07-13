
/*The total revenue and profit split by year + the percentage from total (all years) for revenue and profit*/

select Year(soh.OrderDate) 'Year',
		Sum(sod.LineTotal) Revenue,
		Sum(sod.LineTotal)*100/(Select Sum(LineTotal)
								from Sales.SalesOrderDetail sod) PercentOfTotalRevenue,
		SUM(sod.LineTotal - (sod.OrderQty*pp.StandardCost)) Profit,
		SUM(sod.LineTotal - (sod.OrderQty*pp.StandardCost))*100/(Select SUM(sod.LineTotal - (sod.OrderQty*pp.StandardCost)) 
																 from Sales.SalesOrderDetail sod
																	left join Production.Product pp
																		on sod.ProductID = pp.ProductID) PercentOfTotalProfit
from Sales.SalesOrderDetail sod
	left join Production.Product pp
		on sod.ProductID = pp.ProductID
	left join Sales.SalesOrderHeader soh
		on sod.SalesOrderID = soh.SalesOrderID
Group by Year(soh.OrderDate)
Order by 'Year'

/*The total revenue and profit split by year and month + the percentage from total (all years and months) for revenue and profit*/

select Year(soh.OrderDate) 'Year',
		Month(soh.OrderDate) 'Month',
		Sum(sod.LineTotal) Revenue,
		Round (Sum(sod.LineTotal)*100/(Select Sum(LineTotal)
									   from Sales.SalesOrderDetail), 2) PercentOfTotalRevenue,
		SUM(sod.LineTotal - (sod.OrderQty*pp.StandardCost)) Profit,
		Round (SUM(sod.LineTotal - (sod.OrderQty*pp.StandardCost))*100/(Select SUM(sod.LineTotal - (sod.OrderQty*pp.StandardCost)) 
																        from Sales.SalesOrderDetail sod
																			left join Production.Product pp
																				on sod.ProductID = pp.ProductID),2) PercentOfTotalProfit
from Sales.SalesOrderDetail sod
	left join Production.Product pp
		on sod.ProductID = pp.ProductID
	left join Sales.SalesOrderHeader soh
		on sod.SalesOrderID = soh.SalesOrderID
Group by Year(soh.OrderDate), Month(soh.OrderDate)
Order by 'Year', 'Month'

/*Avg Discount per productID*/

select ProductID,
		AVG (UnitPriceDiscount) AVGDiscount
from Sales.SalesOrderDetail
Group by ProductID
order by AVGDiscount desc

/*Avg discount per month and year*/

select YEAR(soh.OrderDate) 'Year',
		Month(soh.OrderDate) 'Month',
		AVG(sod.UnitPriceDiscount) AVGDiscount
from Sales.SalesOrderDetail sod
	left join Sales.SalesOrderHeader soh
		on sod.SalesOrderID = soh.SalesOrderID
Group by YEAR(soh.OrderDate), Month(soh.OrderDate)
Order by 'Year', 'Month'

/*Total items ordered on every month of the year*/

select Year(soh.OrderDate) 'Year',
		Month(soh.OrderDate) 'Month',
		Sum(sod.OrderQty) TotalQtyOrdered
from sales.SalesOrderHeader soh
	left join Sales.SalesOrderDetail sod
		on soh.SalesOrderID = sod.SalesOrderID
Group by Year(soh.OrderDate), Month(soh.OrderDate)
Order by 'Year', 'Month'

/*Total Orders for each month of every years*/

select distinct Count(SalesOrderID) TotalOrders,
				Year(OrderDate) 'Year',
				Month(OrderDate) 'Month'
from Sales.SalesOrderHeader
Group by Year(OrderDate), Month(OrderDate)
Order by 'Year', 'Month'

/*Total orders*/

select SUM(OrderQty) TotalQtyOrdered
from Sales.SalesOrderDetail

/*Margin for each product*/

select ProductID,
		ListPrice-StandardCost Margin
from Production.Product
group by ProductID, ListPrice-StandardCost
order by Margin desc

/*Avg margin*/

select AVG(ListPrice-StandardCost) AVGMargin
from Production.Product

/*Ranking margin for each product by month and year*/

select Year(soh.OrderDate) 'Year',
		Month(soh.OrderDate) 'Month',
		sod.ProductID,
		SUM(sod.OrderQty) TotalQtyOrdered,
		pp.ListPrice-pp.StandardCost MarginPerProduct,
		SUM(sod.OrderQty*(pp.ListPrice-pp.StandardCost)) TotalMarginPerProduct,
		Dense_Rank () over (partition by Year(soh.OrderDate)
					   Order by SUM(sod.OrderQty*(pp.ListPrice-pp.StandardCost)) desc
					   ) RankingByYear
from Sales.SalesOrderDetail sod
	join Sales.SalesOrderHeader soh
		on sod.SalesOrderID = soh.SalesOrderID
	left join Production.Product pp
		on sod.ProductID = pp.ProductID
group by Year(soh.OrderDate),Month(soh.OrderDate), sod.ProductID, pp.ListPrice-pp.StandardCost
Order by 'Year', RankingByYear

/*Total orders per year*/

select distinct Count(SalesOrderID) AllOrders,
				YEAR(OrderDate) 'Year'
from Sales.SalesOrderHeader
group by YEAR(OrderDate)
Order by 'Year'

/*All discounts applied per each month of all years and when they ended*/

select so.DiscountPct,
		YEAR(so.StartDate) StartDiscountYear,
		Month(so.StartDate) StartDiscountMonth,
		YEAR(so.EndDate) EndDiscountYear,
		Month(so.EndDate) EndDiscountMonth
from Sales.SpecialOffer so
	left join Sales.SpecialOfferProduct sop
		on so.SpecialOfferID = sop.SpecialOfferID
where so.DiscountPct > 0
group by so.DiscountPct, YEAR(so.StartDate), Month(so.StartDate), YEAR(so.EndDate), Month(so.EndDate)
Order by StartDiscountYear, StartDiscountMonth



 


