drop table nomis.dbo.AROutstanding
go
select Cust# as CustNumber,Custname,currency,invoice, CONVERT(SMALLDATETIME,(SUBSTRING(CONVERT(CHAR,Datedue),2,6)),12) as Datedue,CONVERT(SMALLDATETIME,(SUBSTRING(CONVERT(CHAR,DateInv),2,6)),12) as DateInv,
INVAmount,PaymentTD,FXRate,SLS#,Cust_PO ,
case when dateinv >= '1' + convert(VARCHAR,dateadd("d",-30,getdate()),12) then invamount+PAYMENTTD else 0 end as [Current],
case when dateinv between  '1' + convert(VARCHAR,dateadd("d",-45,getdate()),12) and  '1' + convert(VARCHAR,dateadd("d",-31,getdate()),12)   then invamount+PAYMENTTD else 0 end as [Over 30],
case when dateinv between  '1' + convert(VARCHAR,dateadd("d",-60,getdate()),12) and  '1' + convert(VARCHAR,dateadd("d",-46,getdate()),12)  then invamount+PAYMENTTD else 0 end as [Over 45],
case when dateinv between  '1' + convert(VARCHAR,dateadd("d",-90,getdate()),12) and  '1' + convert(VARCHAR,dateadd("d",-61,getdate()),12)  then invamount+PAYMENTTD else 0 end as [Over 60],
case when dateinv between  '1' + convert(VARCHAR,dateadd("d",-120,getdate()),12) and  '1' + convert(VARCHAR,dateadd("d",-91,getdate()),12) then invamount+PAYMENTTD else 0 end as [Over 90],
case when dateinv <  '1' + convert(VARCHAR,dateadd("d",-120,getdate()),12)  then invamount+PAYMENTTD else 0 end as [Over 120],IMRJCD as Div
into nomis.dbo.AROutstanding
from Nomis.S1018252.PCREP.RECAR a
left join Nomis.S1018252.NOMDBF95.SSTPHY01
on convert(varchar,IMT7ND) = REPLACE(LTRIM(REPLACE(Invoice, '0', ' ')), ' ', '0')
order by cust#,custname