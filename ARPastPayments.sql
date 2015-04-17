drop table Nomis.dbo.ARPastPayments
go
select gwzxnb as cust_number
	   ,gwsjcd as check_number
       ,gwsicd as bank_code
       ,gwa3ma as deposit_number
	   ,gwponb as header_check_amount
       ,gwotst as header_check_header_status
       ,case when isdate(SUBSTRING(CONVERT(CHAR,gwd9dt),2,6)) = 1 
			then CONVERT(SMALLDATETIME,(SUBSTRING(CONVERT(CHAR,gwd9dt),2,6)),12) 
		end as header_date_deposit
	   ,CONVERT(SMALLDATETIME,(SUBSTRING(CONVERT(CHAR,gwebdt),2,6)),12)  as header_date_transaction
	   ,GXG7NC as details_seq_nbr
       ,GXSKCD as details_invoice_code       
	   ,gxoust as details_status
       ,gxprnb as details_payment_amount
       ,case when isdate(SUBSTRING(CONVERT(CHAR,gxeddt),2,6)) = 1 
			then CONVERT(SMALLDATETIME,(SUBSTRING(CONVERT(CHAR,gxeddt),2,6)),12) 
		end as details_date_due
       ,CONVERT(SMALLDATETIME,(SUBSTRING(CONVERT(CHAR,imdgdu),2,6)),12) as invoice_date
       ,datediff(d,CONVERT(SMALLDATETIME,(SUBSTRING(CONVERT(CHAR,imdgdu),2,6)),12),CONVERT(SMALLDATETIME,(SUBSTRING(CONVERT(CHAR,gwebdt),2,6)),12)) as Number_of_Days_To_Pay
into Nomis.dbo.ARPastPayments
 from Nomis.S1018252.NOMDBF95.PTGWREP
inner join Nomis.S1018252.NOMDBF95.PTGXREP
on gwaqnb = gxaqnb 
and gwsjcd = gxsjcd
and gwsicd = gxsicd 
and gwa3ma = gxa3ma
inner join (Select distinct IMDGDU, IMT7ND from Nomis.S1018252.NOMDBF95.SSTPHY01 ) as a
on convert(char,GXSKCD) = REPLICATE('0', (9 - LEN(CONVERT(VARCHAR,IMT7ND)))) + CONVERT(VARCHAR,IMT7ND) 
where imdgdu >= 1000000 and gwebdt >= 1000000
order by cust_number,details_invoice_code
--where gwzxnb = 380
--and gwebdt >= 1120614
--go
--
--select distinct imdgdu from 
select * from 
Nomis.dbo.ARPastPayments 
--where details_invoice_code in (
--select details_invoice_code
--from Nomis.dbo.ARPastPayments 
--group by details_invoice_code
--having count(details_invoice_code) > 1)
where cust_number = 380
order by cust_number,check_number

select * from Nomis.S1018252.NOMDBF95.SLSPHY01