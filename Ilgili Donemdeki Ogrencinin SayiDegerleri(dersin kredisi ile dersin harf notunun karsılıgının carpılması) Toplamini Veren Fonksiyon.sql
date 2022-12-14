USE [Okul]


--Ilgili Donemdeki Ogrencinin SayiDegerleri(dersin kredisi ile dersin harf notunun karsılıgının carpılması) Toplamini Veren Fonksiyon:

ALTER function [dbo].[FN$IlgiliDonemdekiOgrencininSayiDegerleriToplami] 
(
 @Donem_Id int,
 @Ogrenci_Id int
 )
returns int
as
begin
declare @sonuc as int

set  @sonuc = 
(select SUM(a.DersinSayiDegeri) 
from (
       select ood.Ogrenci_Id,
              od.Donem_Id,
       	   d.Id as Ders_Id,
       	   dbo.FN$IlgiliDonemdekiOgrencininAldigiDersinSayiDegeri(@Ogrenci_Id,d.Id,@Donem_Id) as DersinSayiDegeri
       from dbo.OgrenciOgretmenDers as ood 
       inner join dbo.OgretmenDers as od on od.Id=ood.OgretmenDers_Id and od.Statu=1
       inner join dbo.Ders as d on d.Id=od.Ders_Id and d.Statu=1
       inner join dbo.Ogrenci as o on o.Id=ood.Ogrenci_Id and o.Statu=1
       inner join dbo.Donem as do on do.Id=od.Donem_Id and do.Statu=1
       where 
       ood.Statu=1
       and do.Id = @Donem_Id
       and ood.Ogrenci_Id=@Ogrenci_Id
       group by  ood.Ogrenci_Id,
                 od.Donem_Id,
       	      d.Id
) A
)


return @sonuc
end



--cagiralim:
select [dbo].[FN$IlgiliDonemdekiOgrencininSayiDegerleriToplami] (1,2)





--where clause kontrolu:

select SUM(a.DersinSayiDegeri) 
from (
       select ood.Ogrenci_Id,
              od.Donem_Id,
       	   d.Id as Ders_Id,
       	   dbo.FN$IlgiliDonemdekiOgrencininAldigiDersinSayiDegeri(2,d.Id,1) as DersinSayiDegeri
       from dbo.OgrenciOgretmenDers as ood 
       inner join dbo.OgretmenDers as od on od.Id=ood.OgretmenDers_Id and od.Statu=1
       inner join dbo.Ders as d on d.Id=od.Ders_Id and d.Statu=1
       inner join dbo.Ogrenci as o on o.Id=ood.Ogrenci_Id and o.Statu=1
       inner join dbo.Donem as do on do.Id=od.Donem_Id and do.Statu=1
       where 
       ood.Statu=1
       and do.Id = 1
       and ood.Ogrenci_Id=2
       group by  ood.Ogrenci_Id,
                 od.Donem_Id,
       	      d.Id
) A