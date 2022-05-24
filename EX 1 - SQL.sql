-- 1.a)

SELECT		P.[Name],OP.[PropertyId] 
FROM		[dbo].[Property] P
INNER JOIN	[dbo].[OwnerProperty] OP
ON		P.AddressId = OP.OwnerId
WHERE		OwnerId = 1426


--1.b)

SELECT		OP.PropertyId, P.[Name], PHV.[Value] HomeValue
FROM		[dbo].[Property] P
INNER JOIN	[dbo].[OwnerProperty] OP
ON		P.AddressId = OP.OwnerId
INNER JOIN	[dbo].[PropertyHomeValue] PHV
ON		PHV.PropertyId = OP.PropertyId
WHERE		OwnerId = 1426
AND 		PHV.IsActive = 1
ORDER BY 	OP.PropertyId


--1.c.i)

SELECT		P.[Name],OP.[PropertyId],TP.[PaymentAmount],TP.[StartDate],TP.[EndDate],

CASE
		WHEN TPF.Id = 1 THEN DATEDIFF(WW,[StartDate],[EndDate])*[PaymentAmount]
		WHEN TPF.Id = 2 THEN DATEDIFF(WW,[StartDate],[EndDate])/2*[PaymentAmount]
		WHEN TPF.Id = 3 THEN DATEDIFF(MM,[StartDate],[EndDate])*[PaymentAmount]
END		TotalPayment

FROM		[dbo].[Property] P
INNER JOIN	[dbo].[OwnerProperty] OP
ON		P.AddressId = OP.OwnerId
INNER JOIN	[dbo].[TenantProperty] TP
ON		TP.PropertyId = OP.PropertyId
INNER  JOIN	[dbo].[TenantPaymentFrequencies] TPF
ON		TP.PaymentFrequencyId = TPF.Id
WHERE		OwnerId = 1426
GROUP BY	P.[Name],OP.[PropertyId],TPF.Id,TP.[PaymentAmount],TP.[StartDate],TP.[EndDate]


--c.ii)

SELECT		P.[Name],OP.[PropertyId],PF.[Yield]
FROM		[dbo].[Property] P
INNER JOIN	[dbo].[OwnerProperty] OP
ON		P.AddressId = OP.OwnerId
INNER JOIN	[dbo].[PropertyFinance] PF
ON		OP.PropertyId = PF.PropertyId
WHERE		OwnerId = 1426


--1.d)

SELECT		J.JobDescription Job, JS.Status Availability
FROM		[dbo].[Job] J
INNER JOIN	[dbo].[JobStatus] JS
ON		J.[JobStatusId] = JS.Id
WHERE		JobStatusId = 1


--1.e)

SELECT		P.[Name],OP.[PropertyId],PE.[FirstName], PE.LastName,

CASE
		WHEN TPF.Id = 1 THEN TP.[PaymentAmount]
		WHEN TPF.Id = 2 THEN TP.[PaymentAmount]/2
		WHEN TPF.Id = 3 THEN TP.[PaymentAmount]/4
END		WeeklyPayment,

CASE
		WHEN TPF.Id = 1 THEN TP.[PaymentAmount]*2
		WHEN TPF.Id = 2 THEN TP.[PaymentAmount]
		WHEN TPF.Id = 3 THEN TP.[PaymentAmount]/2
END		FortnightlyPayment,

CASE
		WHEN TPF.Id = 1 THEN TP.[PaymentAmount]*4
		WHEN TPF.Id = 2 THEN TP.[PaymentAmount]*2
		WHEN TPF.Id = 3 THEN TP.[PaymentAmount]
END		MonthlyPayment

FROM		[dbo].[Property] P
INNER JOIN	[dbo].[OwnerProperty] OP
ON		P.AddressId = OP.OwnerId
INNER JOIN	[dbo].[TenantProperty] TP
ON		P.PropertyId = OP.PropertyId
INNER  JOIN	[dbo].[TenantPaymentFrequencies] TPF
ON		TP.PaymentFrequencyId = TPF.Id
INNER JOIN	[dbo].[Person] PE
ON		PE.Id = TP.Id
WHERE		OwnerId = 1426
GROUP BY	P.[Name],OP.[PropertyId],TPF.Id,TP.[PaymentAmount],TP.[StartDate],TP.[EndDate],PE.[FirstName], PE.LastName