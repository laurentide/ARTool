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
left join (select distinct imt7nd,imrjcd from Nomis.S1018252.NOMDBF95.SSTPHY01) as b
on convert(varchar,IMT7ND) = REPLACE(LTRIM(REPLACE(Invoice, '0', ' ')), ' ', '0')
order by cust#,custname
go
--drop index ix_ArOutstanding_Cust ON nomis.dbo.AROutstanding
--go
create clustered index  ix_ArOutstanding_Cust  on nomis.dbo.AROutstanding (custnumber)
alter table nomis.dbo.AROutstanding add primary key (invoice)
go
drop table Nomis.dbo.ArOutStanding_Grouped
go
select  CustNumber, Custname,Currency,
        count(invoice) as [Number of invoices], 
        min(Datedue) as [closest due],
        min(DateInv) as [Oldest Invoice Date], 
        min(datediff(day,Datedue,getdate())) as [closest due days],
        min(datediff(day,DateInv,getdate())) as [Oldest Invoice Date days], 
        sum(invamount) as [Total Invoiced], 
        sum(paymenttd) as [Sum of Payments to Date], 
        sum([current]) as [Current Outstanding],
        sum([over 30]) as [Over 30], 
        sum([over 45]) as [Over 45],
        sum([Over 60]) as [Over 60],
        sum([Over 90]) as [Over 90],
        sum([Over 120]) as [Over 120]
		into Nomis.dbo.ArOutStanding_Grouped
                    from nomis.dbo.AROutstanding
                    group by CustNumber, Custname,Currency
                    go
                    select CustNumber,count(*) from Nomis.dbo.ArOutStanding_Grouped
                    group by CustNumber
                    go
                    select * from Nomis.dbo.ArOutStanding_Grouped
go
ALTER TABLE Nomis.dbo.ArOutStanding_Grouped ADD PRIMARY KEY (CustNumber);
go
--select Cust# as CustNumber,Custname,currency,invoice, CONVERT(SMALLDATETIME,(SUBSTRING(CONVERT(CHAR,Datedue),2,6)),12) as Datedue,CONVERT(SMALLDATETIME,(SUBSTRING(CONVERT(CHAR,DateInv),2,6)),12) as DateInv,
--INVAmount,PaymentTD,FXRate,SLS#,Cust_PO ,
--case when dateinv >= '1' + convert(VARCHAR,dateadd("d",-30,getdate()),12) then invamount+PAYMENTTD else 0 end as [Current],
--case when dateinv between  '1' + convert(VARCHAR,dateadd("d",-45,getdate()),12) and  '1' + convert(VARCHAR,dateadd("d",-31,getdate()),12)   then invamount+PAYMENTTD else 0 end as [Over 30],
--case when dateinv between  '1' + convert(VARCHAR,dateadd("d",-60,getdate()),12) and  '1' + convert(VARCHAR,dateadd("d",-46,getdate()),12)  then invamount+PAYMENTTD else 0 end as [Over 45],
--case when dateinv between  '1' + convert(VARCHAR,dateadd("d",-90,getdate()),12) and  '1' + convert(VARCHAR,dateadd("d",-61,getdate()),12)  then invamount+PAYMENTTD else 0 end as [Over 60],
--case when dateinv between  '1' + convert(VARCHAR,dateadd("d",-120,getdate()),12) and  '1' + convert(VARCHAR,dateadd("d",-91,getdate()),12) then invamount+PAYMENTTD else 0 end as [Over 90],
--case when dateinv <  '1' + convert(VARCHAR,dateadd("d",-120,getdate()),12)  then invamount+PAYMENTTD else 0 end as [Over 120],IMRJCD as Div
----into nomis.dbo.AROutstanding
--from Nomis.S1018252.PCREP.RECAR a
--left join Nomis.S1018252.NOMDBF95.SSTPHY01
--on convert(varchar,IMT7ND) = REPLACE(LTRIM(REPLACE(Invoice, '0', ' ')), ' ', '0')
--order by cust#,custname
--go