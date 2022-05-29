-- 1.a)

SELECT		P.[Name] PropertyName,OP.[PropertyId] 
FROM		[dbo].[Property] P
INNER JOIN	[dbo].[OwnerProperty] OP
ON			P.Id = OP.PropertyId
WHERE		OwnerId = 1426


--1.b)

SELECT		OP.PropertyId, P.[Name] PropertyName, PHV.[Value] HomeValue
FROM		[dbo].[Property] P
INNER JOIN	[dbo].[OwnerProperty] OP
ON			P.Id = OP.PropertyId
INNER JOIN	[dbo].[PropertyHomeValue] PHV
ON			PHV.PropertyId = OP.PropertyId
WHERE		OwnerId = 1426
AND 		PHV.IsActive = 1
ORDER BY 	OP.PropertyId


--1.c.i)

SELECT		P.[Name] PropertyName,OP.[PropertyId],TP.[PaymentAmount],TP.[StartDate] PaymentStartDate,TP.[EndDate]PaymentEndDate,

CASE
			WHEN TPF.Id = 1 THEN DATEDIFF(WW,[StartDate],[EndDate])*[PaymentAmount]
			WHEN TPF.Id = 2 THEN DATEDIFF(WW,[StartDate],[EndDate])/2*[PaymentAmount]
			WHEN TPF.Id = 3 THEN DATEDIFF(MM,[StartDate],[EndDate])*[PaymentAmount]
END			TotalPayment

FROM		[dbo].[Property] P
INNER JOIN	[dbo].[OwnerProperty] OP
ON			P.Id = OP.PropertyId
INNER JOIN	[dbo].[TenantProperty] TP
ON			TP.PropertyId = OP.PropertyId
INNER  JOIN	[dbo].[TenantPaymentFrequencies] TPF
ON			TP.PaymentFrequencyId = TPF.Id
WHERE		OwnerId = 1426
GROUP BY	P.[Name],OP.[PropertyId],TPF.Id,TP.[PaymentAmount],TP.[StartDate],TP.[EndDate]


--c.ii)

SELECT		P.[Name] PropertyName,OP.[PropertyId],

CASE
			WHEN TPF.Id = 1 THEN (((DATEDIFF(WW,[StartDate],[EndDate])*[PaymentAmount])-PE.[Amount])/PHV.Value)*100
			WHEN TPF.Id = 2 THEN (((DATEDIFF(WW,[StartDate],[EndDate])/2*[PaymentAmount])-ISNULL(PE.[Amount],0))/PHV.Value)*100
			WHEN TPF.Id = 3 THEN (((DATEDIFF(MM,[StartDate],[EndDate])*[PaymentAmount])-PE.[Amount])/PHV.Value)*100
END			TotalPayment

FROM		[dbo].[Property] P
INNER JOIN	[dbo].[OwnerProperty] OP
ON			P.Id = OP.PropertyId
INNER JOIN	[dbo].[TenantProperty] TP
ON			TP.PropertyId = OP.PropertyId
INNER  JOIN	[dbo].[TenantPaymentFrequencies] TPF
ON			TP.PaymentFrequencyId = TPF.Id
LEFT JOIN	[dbo].[PropertyExpense] PE
ON			PE.PropertyId = TP.PropertyId
INNER JOIN	[dbo].[PropertyHomeValue] PHV
ON			PHV.[PropertyId] = OP.PropertyId
WHERE		OwnerId = 1426 AND PHV.[IsActive] = 1
GROUP BY	P.[Name],OP.[PropertyId],TPF.Id,TP.[PaymentAmount],TP.[StartDate],TP.[EndDate],PHV.Value,PE.[Amount]


--1.d)

SELECT		J.JobDescription Job, JS.Status Availability
FROM		[dbo].[Job] J
INNER JOIN	[dbo].[JobStatus] JS
ON			J.[JobStatusId] = JS.Id
WHERE		JobStatusId = 1


--1.e)


SELECT		P.[Name] PropertyName,OP.[PropertyId],PE.[FirstName]TenantName, PE.LastName TenantLastName,

CASE
			WHEN TPF.Id = 1 THEN TP.[PaymentAmount]
			WHEN TPF.Id = 2 THEN TP.[PaymentAmount]/2
			WHEN TPF.Id = 3 THEN TP.[PaymentAmount]/4
END			WeeklyPayment,

CASE
			WHEN TPF.Id = 1 THEN TP.[PaymentAmount]*2
			WHEN TPF.Id = 2 THEN TP.[PaymentAmount]
			WHEN TPF.Id = 3 THEN TP.[PaymentAmount]/2
END			FortnightlyPayment,

CASE
			WHEN TPF.Id = 1 THEN TP.[PaymentAmount]*4
			WHEN TPF.Id = 2 THEN TP.[PaymentAmount]*2
			WHEN TPF.Id = 3 THEN TP.[PaymentAmount]
END			MonthlyPayment

FROM		[dbo].[Property] P
INNER JOIN	[dbo].[OwnerProperty] OP
ON			P.Id = OP.PropertyId
INNER JOIN	[dbo].[TenantProperty] TP
ON			TP.PropertyId = OP.PropertyId
INNER JOIN	[dbo].[TenantPaymentFrequencies] TPF
ON			TP.PaymentFrequencyId = TPF.Id
INNER JOIN	[dbo].[Person] PE
ON			PE.Id = TP.Id
WHERE		OwnerId = 1426
GROUP BY	P.[Name],OP.[PropertyId],TPF.Id,TP.[PaymentAmount],TP.[StartDate],TP.[EndDate],PE.[FirstName], PE.LastName