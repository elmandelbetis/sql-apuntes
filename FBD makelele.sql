select distinct codpro, sum(cantidad) from ventas group by codpro order by codpro asc; --Ejercicio 3.2 (mejorao)

select codpie from pieza where ciudad='Madrid' and (color='Rojo' or color='Gris'); --Ejercicio 3.3

select distinct codpro, cantidad from ventas where cantidad between 200 and 300; -- Ejercicio 3.4

select codpie from pieza where nompie like 'Tor%' or nompie like 'tor%'; -- Ejercicio 3.5

select distinct ciudad from proveedor where status>2
intersect
select ciudad from proveedor where ciudad not in (select ciudad from pieza where codpie='P1'); -- Ejercicio 3.7

select codpj from ventas where codpro ='S1' 
minus
select codpj from ventas where codpro<>'S1'; -- Ejercicio 3.8: no saca nada porque no hay proyecto abastecido SÓLO por S1

select ciudad from proveedor union all select ciudad from pieza union all select ciudad from proyecto; -- Ejercicios 3.9 y 3.10

select * from ventas, proveedor; -- Ejercicio 3.11: 217 tuplas

select distinct proveedor.codpro, proveedor.ciudad as ciudad_proveedor, pieza.codpie, pieza.ciudad as ciudad_pieza, proyecto.codpj, proyecto.ciudad as ciudad_proyecto
from proveedor, pieza, proyecto, ventas
where proveedor.ciudad=proyecto.ciudad
and proyecto.ciudad=pieza.ciudad
and ventas.cantidad>0; -- Ejercicio 3.12

-- AR del ej 3.12: ?proveedor.codpro,proveedor.ciudad,pieza.codpie,pieza.ciudad,proyecto.codpj,proyecto.ciudad(?(proveedor.ciudad=proyecto.ciudad and pieza.ciudad=proyecto.ciudad)(((proveedor x pieza) x proyecto) x ?ventas.cantidad>0(ventas)))

select distinct p1.codpro as proveedor_1, p2.codpro as proveedor_2
from proveedor p1, proveedor p2
where p1.ciudad<>p2.ciudad; -- Ejercicio 3.13

-- AR del ej 3.13: ?p1.codpro,p2.codpro(?p1.ciudad<>p2.ciudad (? p1 (proveedor) x ? p2 (proveedor)))

select p1.nompie, p1.peso
from pieza p1
where p1.peso >= all(select p2.peso from pieza p2); -- Ejercicio 3.14

select codpie, nompie 
from pieza natural join (select * from proveedor where ciudad='Madrid'); --Ejercicio 3.15


select distinct ciudad from ventas
natural join (select distinct ciudad, codpro, codpj from proveedor 
natural join proyecto);


select nompro from proveedor order by nompro; -- Ejercicio 3.17: la cláusula los saca en orden alfabético

select * from ventas order by cantidad, fecha desc; -- Ejercicio 3.18

select codpie,nompie from pieza where ciudad in (select ciudad from proveedor where ciudad='Madrid'); --Ejercicio 3.19

select codpj,ciudad from proyecto where ciudad in (select ciudad from pieza); --Ejercicio 3.20
--AR: ?proyecto.codpj,proyecto.ciudad(?(proyecto.ciudad=pieza.ciudad)(proyecto x pieza))


select codpj from proyecto
where codpj not in (
    select distinct codpj from ventas
    natural join (select codpie from pieza where color='Rojo')
    natural join (select codpro from proveedor where ciudad='Londres'));


select codpro
from proveedor
where exists (select * from ventas
              where ventas.codpro = proveedor.codpro and ventas.codpie='P1');

select codpro
from proveedor
where status = (select status from proveedor where codpro='S3');

select codpie from pieza
where peso > any (select peso from pieza where nompie like 'Tornillo%'); --Ejercicio 3.22

select codpie, nompie
from pieza
where peso >= all (select peso from pieza); --Ejercicio 3.23


-- DIVISIÓN RELACIONAL (QUE DIOS ME COJA CONFESADO)

select distinct codpie from pieza
where not exists
(
    select distinct codpj from proyecto where ciudad like 'Lo%'
    minus
    select distinct v.codpj from ventas v where
    v.codpie=pieza.codpie
); -- Ejercicio 3.24


select distinct codpro from proveedor where not exists(
    select pi.codpie from pieza pi join proyecto pr on pi.ciudad = pr.ciudad
    minus
    select distinct v.codpie from ventas v where v.codpro=proveedor.codpro
); -- Ejercicio 3.25


select count(*) from ventas where cantidad>1000; -- Ejercicio 3.26

select max(peso) from pieza; --Ejercicio 3.27

select codpie,peso from pieza
where peso = (select max(peso) from pieza); --Ejercicio 3.28

select codpro from proveedor
where (select count(*) from ventas where ventas.codpro=proveedor.codpro) > 3; 
-- Ejercicio 3.29
        

select codpro, count(*), max(cantidad)
from ventas
group by (codpro);  --Ejemplo 3.20: Para cada proveedor, mostrar la cantidad de
                    --ventas realizadas y el máx de unidades suministrado en una venta
                    
    
--Ejercicio 3.31
select distinct v.codpie, p.nompie, ceil(avg(v.cantidad)) from ventas v
join pieza p on v.codpie=p.codpie
group by (v.codpie, p.nompie)
order by codpie;


--Ejercicio 3.32
select codpro, codpie, ceil(avg(cantidad)) as media_ventas_pieza from ventas
natural join (select codpie from pieza where codpie='P1')
group by (codpro, codpie);


--Ejercicio 3.33
select distinct v.codpie, sum(v.cantidad) as total_piezas_por_cada_proyecto from ventas v
join proyecto pr on v.codpj=pr.codpj
join pieza p on v.codpie=p.codpie
group by (v.codpie)
order by codpie; 


--Ejemplo 3.21: Hallar la cantidad media de ventas realizadas por cada proveedor,
--indicando solamente los códigos de proveedores que han hecho más de 3 ventas
select codpro, avg(cantidad)
from ventas
group by (codpro)
having count(*)>3;


--Ejemplo 3.22: Mostrar la media de unidades vendidas de la pieza 'P1' realizadas
--por cada proveedor, indicando solamente la información de aquellos proveedores
--que han hecho entre 2 y 10 ventas
select codpro, codpie, avg(cantidad)
from ventas
where codpie='P1'
group by (codpro, codpie) having count(*) between 2 and 10;


--Ejemplo 3.23: Encuentra los nombres de proyectos y cantidad media de piezas 
--que recibe por proveedor
select v.codpro, v.codpj, pj.nompj, avg(v.cantidad)
from ventas v, proyecto pj
where v.codpj=pj.codpj
group by (v.codpj, pj.nompj, v.codpro);


--Ejercicio 3.34: Corregir el ejemplo 3.24
select pj.nompj as proyecto, p.codpro as recibe_de, avg(v.cantidad) as media_piezas
from ventas v
join proveedor p on v.codpro=p.codpro
join proyecto pj on v.codpj=pj.codpj
group by (v.codpro, v.codpj, pj.nompj)
order by p.codpro, v.codpj;


--Ejercicio 3.35: Mostrar los nombres de proveedores tales que el total de 
--sus ventas superen la cantidad de 1000 unidades
select v.codpro, p.nompro, sum(v.cantidad) as cantidad_vendida from ventas v
join proveedor p on v.codpro=p.codpro
group by (v.codpro,p.nompro)
having sum(v.cantidad)>1000
order by codpro;


--Ejercicio 3.36
select codpie, sum(cantidad) from ventas
group by codpie
having sum(cantidad) = (select max(sum(v.cantidad)) from ventas v
                        group by v.codpie);


--Ejercicio 3.38
select codpie, to_char(fecha,'MM/YYYY'), avg(cantidad) from ventas
group by (codpie, to_char(fecha,'MM/YYYY'));


-- EJERCICIOS ADICIONALES, JUJU, AHORA SÍ SE VIENE LO CHIDO --

-- Ejercicio 3.42
select codpro from ventas
group by codpro
having count(*) >= (select count(*) from ventas where codpro='S1');
-- No devuelve nada porque ningún proveedor tiene más ventas que S1

select distinct codpro, count(*) from ventas
group by codpro; -- Consulta para comprobar que está bien


--Ejercicio 3.43
select distinct codpro, sum(cantidad)
from ventas
group by codpro
having sum(cantidad) >= (select max(sum(v.cantidad)) from ventas v
                         join proveedor p on v.codpro=p.codpro
                         group by v.codpro);
                         
--Ejercicio 3.44
select codpro from proveedor where not exists
(select pj.ciudad from proyecto pj join ventas v on pj.codpj=v.codpj where v.codpro='S3' -- Ciudades donde suministra S3
minus
select pj.ciudad from proyecto pj join ventas v on pj.codpj=v.codpj where v.codpro=proveedor.codpro) --Ciudades adonde suministra el proveedor actual
and codpro <> 'S3';


--Ejercicio 3.45
select codpro, count(*) from ventas 
group by codpro
having count(*)>=10;


--Ejercicio 3.46 (rehacer para entenderlo mañana)
select codpro from proveedor where not exists(
    select pi.codpie from pieza pi join ventas v on pi.codpie=v.codpie where v.codpro='S1'
    minus
    select v.codpie from ventas v where v.codpro=proveedor.codpro
) and codpro<>'S1';


--Ejercicio 3.47 (lo mismo que 3.46)
select codpro, sum(cantidad) as suma from ventas where codpro in (
    select codpro from proveedor where not exists(
        select pi.codpie from pieza pi join ventas v on pi.codpie=v.codpie where v.codpro='S3'
        minus
        select v.codpie from ventas v where v.codpro=proveedor.codpro
    ) and codpro <> 'S3' 
) group by codpro order by suma;


--Ejercicio 3.48
select p.codpj from proyecto p where not exists(
    select distinct codpro from ventas where codpie='P3' --Proveedores que suministran P3
    minus
    select codpro from ventas v where v.codpj=p.codpj
);


--Ejercicio 3.49
select v.codpro, avg(v.cantidad) from ventas v 
join pieza p on v.codpie=p.codpie where p.codpie='P3'
group by (v.codpro);


--Ejercicio 3.50


--Ejercicio 3.51


--Ejercicio 3.52
select distinct codpro, round(avg(cantidad),3), to_char(fecha, 'YYYY') from ventas
group by codpro, to_char(fecha, 'YYYY')
order by codpro, to_char(fecha,'YYYY') asc;


--Ejercicio 3.53
select distinct codpro from ventas v
join pieza pi on v.codpie = pi.codpie
where pi.color='Rojo'
order by codpro asc;
    

--Ejercicio 3.54
select distinct v.codpro from ventas v 
join pieza pi on pi.codpie=v.codpie where pi.color='Rojo'
group by v.codpro
having count(distinct pi.codpie) = (select count(distinct codpie) from pieza where color='Rojo')
order by codpro asc;


--Ejercicio 3.55
select distinct codpro from proveedor where codpro not in(
    select v.codpro from ventas v 
    join pieza pi on v.codpie=pi.codpie where pi.color <> 'Rojo'
);


--Ejercicio 3.56
select p.codpro, p.nompro from proveedor p
join(
    select v.codpro from ventas v join pieza pi on v.codpie=pi.codpie 
    where pi.color='Rojo'
    group by v.codpro
    having count(v.codpie) > 1
) proveedores_mas_1_rojo on p.codpro=proveedores_mas_1_rojo.codpro;


--Ejercicio 3.57

-- Interpretación 1: que los proveedores que venden todas las piezas rojas venden siempre > 10 piezas de TODO tipo
select v.codpro from ventas v 
where v.codpro in(
    select v.codpro from ventas v join pieza pi on pi.codpie=v.codpie where pi.color='Rojo'
    group by v.codpro
    having count(distinct pi.codpie) = (select count(distinct codpie) from pieza 
                                     where color='Rojo')
)
group by v.codpro
having count(*) = (select count(*) from ventas v2 where v2.codpro=v.codpro and v2.cantidad>10);

--Interpretación 2: que sólo se limite a las piezas rojas y no a todas (mucho más fácil)
select distinct v.codpro
from ventas v
join pieza pi on pi.codpie = v.codpie
where pi.color = 'Rojo'
and v.cantidad > 10
group by v.codpro
having count(distinct v.codpie) = (select count(*) from pieza pi where pi.color='Rojo')
order by v.codpro;


--Ejercicio 3.58
update proveedor
set status=1 where codpro in(
    select distinct codpro from ventas where codpie='P1'
);
select * from proveedor;
rollback;


--Ejercicio 3.59: Porrazo enorme
select pi.ciudad from pieza pi join ventas v on pi.codpie=v.codpie
group by pi.ciudad
having sum(v.cantidad) = (select max(sum(cantidad))
                         from ventas v
                         join pieza pi on v.codpie = pi.codpie
                         where to_char(fecha,'MM/YYYY') = '08/2009'
                         group by pi.ciudad);
                         
select * from ventas order by fecha; --No hay ni una venta hecha en Agosto de 2009 :v


--EJERCICIOS ADICIONALES BASE DE DATOS DEPORTES--

--Ejercicio 3.60
select * from encuentros;


--Ejercicio 3.61
select nombreE as Equipo, nombreJ as Jugador from equipos, jugadores
where equipos.codE=jugadores.codE
order by nombreJ; --ordenamos alfabéticamente a partir de los jugadores (o eso quiere decir el enunciado no sé)


--Ejercicio 3.62
select codJ, nombreJ from jugadores where codJ not in(
    select codJ from faltas);
    
select codJ, nombreJ from jugadores
natural join (select codJ from faltas); --comprobación


--Ejercicio 3.63
select codJ, nombreJ from jugadores 
where codE = (
    select codE from jugadores
    where codJ='A2'
) and codJ <> 'A2';


--Ejercicio 3.64
select j.nombreJ, e.localidad from jugadores j, equipos e
where j.codE=e.codE;


--Ejercicio 3.65
select e1.codE as local, e2.codE as visitante
from equipos e1
join equipos e2 on e1.codE <> e2.codE;


--Ejercicio 3.66
select distinct e.codE, e.nombreE from equipos e
join encuentros en on e.codE=en.eq1
where res1 > res2;


--Ejercicio 3.67
select distinct e.codE, e.nombreE from equipos e
join encuentros en on (e.codE = en.eq1 or e.codE = en.eq2)
where (res1 > res2 or res2 > res1)
order by nombreE;


--Ejercicio 3.68 (no es una división, piensa)



--Ejercicio 3.69
select codE, nombreE from equipos where codE not in(
    select distinct eq1 from encuentros where res1 < res2
);


--Ejercicio 3.70
(select e1.codE as local, e2.codE as visitante
from equipos e1
join equipos e2 on e1.codE <> e2.codE)

minus

(select eq1, eq2 from encuentros);


--Ejercicio 3.71
select enc.eq1, enc.eq2 from encuentros enc
join equipos e1 on enc.eq1=e1.codE
join equipos e2 on enc.eq2=e2.codE
where e1.localidad=e2.localidad and e2.localidad=e1.localidad;


--Ejercicio 3.72
select distinct e.nombreE as Equipo, count(*) as Encuentros_disputados 
from equipos e
join encuentros enc on e.codE=enc.eq1
group by e.nombreE;


--Ejercicio 3.73
select eq1, eq2, res1, res2 from encuentros
where abs(res1 - res2) = (select max(abs(res1-res2)) 
from encuentros);


--Ejercicio 3.74
select j.codJ, f.num from jugadores j
join faltas f on j.codJ=f.codJ
group by j.codJ, f.num
having sum(f.num) <= 3;


--Ejercicio 3.75
select codE, nombreE, total_fuera_casa from(
    select e.codE, e.nombreE, sum(enc.res2) as total_fuera_casa from equipos e
    join encuentros enc on e.codE=enc.eq2
    group by e.codE, e.nombreE
    order by total_fuera_casa desc
)
where rownum=1; -- trucazo que me ha enseñado mi colega chatgpt

select e.codE, max(sum(enc.res2)) from equipos e
join encuentros enc on e.codE=enc.res2
group by e.codE;

--Ejercicio 3.76
select e.codE, count(*) from equipos e
join encuentros enc on e.codE=enc.eq1 or e.codE=enc.eq2
where enc.res1 > enc.res2 or enc.res2 > enc.res1
group by e.codE;


--Ejercicio 3.77
select e.codE, count(*) from equipos e
join encuentros enc on e.codE=enc.eq1 or e.codE=enc.eq2
where enc.res1 > enc.res2 or enc.res2 > enc.res1
group by e.codE
having count(*) = (select max(count(*)) from equipos e
                   join encuentros enc on e.codE=enc.eq1 or e.codE=enc.eq2
                   where enc.res1 > enc.res2 or enc.res2 > enc.res1
                   group by e.codE);


--Ejercicio 3.78 (encuentros de ida? q coño? nah lo hago de todos y ya)
select e.codE, avg(res1) as media_puntos_local, avg(res2) as media_puntos_visitante
from equipos e
join encuentros enc on e.codE=enc.eq1 or e.codE=enc.eq2
group by e.codE;
--Esto también está mal

select nombreE as equipo, avg(puntos) as promedio_puntos
from (
    select eq1 as equipo, res1 as puntos
    from encuentros
    union all
    select eq2, res2 as puntos
    from encuentros
) puntos_por_equipo
join equipos on codE = puntos_por_equipo.equipo
group by nombreE;


--Ejercicio 3.79
select e.codE, e.nombreE, sum(enc.res1) as total_puntos_local, sum(enc.res2) as total_puntos_visitante 
from equipos e
join encuentros enc on e.codE=enc.eq1 or e.codE=enc.eq2
group by e.codE, e.nombreE;
-- Esto está jodidamente mal



select * from equipos;
select * from encuentros where eq1='FCB' or eq2='FCB';

select * from x5342754.conpersmisobuenastardes;



-- VISTAS --
create view VentasRealizadasEnParis(codpro, codpie, codpj, cantidad, fecha) as
    select * from ventas where (codpro, codpie, codpj) in
        (select codpro, codpie, codpj from proveedor, pieza, proyecto
        where proveedor.ciudad='Paris' and pieza.ciudad='Paris' and proyecto.ciudad='Paris');
-- Creación de vistas: ejemplo 1

create view PiezasLondres as
    select codpie, nompie, color, peso from pieza
    where pieza.ciudad='Londres'; -- Creación de vistas: ejemplo 2
    
select * from VentasRealizadasEnParis;
select * from PiezasLondres;

insert into PiezasLondres values ('P9', 'Pieza 9', 'rojo', 90); --inserción
select * from pieza;
commit;

drop view VentasRealizadasEnParis; --borrado de vistas


-- Ejercicio 4.1
create view ProveedoresLondres as
    select * from proveedor where proveedor.ciudad='Londres';
    
insert into ProveedoresLondres values('S7','Jose Suarez',3,'Granada');
-- ya existe un proveedor S7 así que como es la clave primaria, no nos deja ponerlo


--Ejercicio 4.2
create view ProveedoresCiudades as
    select nompro, ciudad from proveedor;++

select * from ProveedoresCiudades;

insert into ProveedoresCiudades values('Oscar Puente','Cuenca'); --Inserción nula en codpro(CP)


--Ejercicio 4.3
create view ProvProyPiezasGrises as
    select distinct p.codpro, p.nompro, pr.codpj from proveedor p
    join ventas v on p.codpro=v.codpro
    join pieza pi on v.codpie=pi.codpie
    join proyecto pr on v.codpj=pr.codpj
    where pi.color='Gris';
    
select * from ProvProyPiezasGrises;

INSERT INTO ProvProyPiezasGrises (codpro, nompro, codpj)
VALUES ('P123', 'Proveedor XYZ', 'PJ456');




-- CATÁLOGO Y GESTIÓN DE PRIVILEGIOS --

--Ejercicio 5.1
describe USER_TABLES;


--Ejercicio 5.2
create table acceso (testigo number);
insert into acceso values(1);
insert into acceso values(2);

grant select on acceso to x5342754;

-- ÍNDICES, CLUSTERS Y HASHING --
create index indice_proveedores on proveedor(nompro);
select * from user_indexes where index_name like 'INDICE_PROVEEDORES';


CREATE TABLE Prueba_Bit (color Varchar2(10));

create index Prueba_IDX on prueba_bit(color);
SELECT count(*) FROM Prueba_Bit
WHERE color='Amarillo' OR color= 'Azul'; --0.067 segundos

drop index prueba_idx;
create bitmap index prueba_bitmap_idx on prueba_bit(color);
SELECT count(*) FROM Prueba_Bit
WHERE color='Amarillo' OR color= 'Azul'; --0.051 segundos

drop table prueba_bit;

CREATE TABLE Prueba_IOT (id NUMBER PRIMARY KEY) ORGANIZATION INDEX;



-- CLÚSTERES --
CREATE CLUSTER cluster_codpro(codpro VARCHAR2(3)); 

CREATE TABLE proveedor2(
codpro VARCHAR2(3) PRIMARY KEY,
nompro VARCHAR2(30) NOT NULL,
status NUMBER(2) CHECK(status>=1 AND status<=10),
ciudad VARCHAR2(15))
CLUSTER cluster_codpro(codpro);

CREATE TABLE ventas2(
codpro VARCHAR2(3) REFERENCES proveedor2(codpro),
codpie REFERENCES pieza(codpie),
codpj REFERENCES proyecto(codpj),
cantidad NUMBER(4),
fecha DATE,
PRIMARY KEY (codpro,codpie,codpj))
CLUSTER cluster_codpro(codpro);

CREATE INDEX indice_cluster ON CLUSTER cluster_codpro;

insert into proveedor2 select * from proveedor;
insert into ventas2 select * from ventas;

select codpro from proveedor2; --0,034s
select codpro from proveedor; --0.031s