--PARA CORREGIR CIERRE DE INTERFACE BIOMETRICO
update yp_cas_assistance set atraso='00:00:00', falta='00:00:00', h1='00:00:00', h2='00:00:00', h3='00:00:00', h4='00:00:00'
where (depurado=32 or depurado=33) and atraso is null and falta is null and h1 is null and h2 is null and h3 is null and h4 is null

--PARA CORREGIR CIERRE DE INTERFACE BIOMETRICO
update YP_CAS_DETTRANSACTION set H1='00:00:00' where H1 is null ;
update YP_CAS_DETTRANSACTION set H2='00:00:00' where H2 is null ;
update YP_CAS_DETTRANSACTION set H3='00:00:00' where H3 is null ;
update YP_CAS_DETTRANSACTION set H4='00:00:00' where H4 is null ;

--PARA ACTUALIZAR ERROR EN CALCULO DE FALTAS Y H EXTRAS, ejecutar línea por línea en servidor

update YP_CAS_SUMMARY set H1='00:00:00' where H1 isnull;
update YP_CAS_SUMMARY set H2='00:00:00' where H2 isnull;
update YP_CAS_SUMMARY set H3='00:00:00' where H3 isnull;
update YP_CAS_SUMMARY set H4='00:00:00' where H4 isnull;

SELECT  H1,H2,H3,H4, * FROM YP_CAS_DETTRANSACTION WHERE YEAR(FECHA)='2022' AND MONTH(FECHA)='03'

--EJECUTAR EN EL SERVIDOR
update YP_CAS_DETTRANSACTION set H1='00:00:00' where H1='00_:_:_';
update YP_CAS_DETTRANSACTION set H2='00:00:00' where H2='00_:_:_';
update YP_CAS_DETTRANSACTION set H4='00:00:00' where H4='00_:_:_';
update YP_CAS_DETTRANSACTION set H1='00:00:00' where H1='00_:__:__';
update YP_CAS_DETTRANSACTION set H2='00:00:00' where H2='00_:__:__';
update YP_CAS_DETTRANSACTION set H3='00:00:00' where H3='00_:__:__';
update YP_CAS_DETTRANSACTION set H4='00:00:00' where H4='00_:__:__';


--ESTO PUEDE OMITIRSE
/*
update YP_CAS_DETTRANSACTION set H1='00:00:00' where H1='000:00:00';
update YP_CAS_DETTRANSACTION set H2='00:00:00' where H2='000:00:00';
update YP_CAS_DETTRANSACTION set H3='00:00:00' where H3='000:00:00';
update YP_CAS_DETTRANSACTION set H4='00:00:00' where H4='000:00:00';
*/

---ACTUALIZAR ERROR EN CALCULO DE EXTRAS Y ATRASOS 
SELECT * FROM yp_cas_assistance WHERE anio = 2022 and mes=4 AND ATRASO like '%-%' 
SELECT * FROM yp_cas_assistance WHERE yp_cas_assistance.FUNCIONARIO=2016 and FALTA = '-16:00:00'
select * from yp_cas_assistance where h4 LIKE '-%'
select * from yp_cas_assistance where FALTA = '-16:00:00'

--PARA VER CUANTAS HORAS ES POR JORNADA SEGÚN CODIGO
SELECT * FROM yp_cas_det_workingday where codigo='559'

--PARA CORREGIR FALTAS NEGATIVAS EN CALCULO DE EXTRAS Y FALTAS
UPDATE yp_cas_assistance SET Falta='06:00:00' WHERE Falta='-18:00:00' AND Jornada in (18,22,423);
UPDATE yp_cas_assistance SET Falta='08:00:00' WHERE Falta='-16:00:00' AND Jornada in (4,372,374,425,548,108, 559);
UPDATE yp_cas_assistance SET Falta='12:00:00' WHERE Falta='-12:00:00' AND Jornada = 132;
UPDATE yp_cas_assistance SET Falta='15:00:00' WHERE Falta='-09:00:00' AND Jornada = 322;

UPDATE yp_cas_assistance SET h3=SUBSTRING(h3,2, 9) WHERE h3 like '%-%' and anio = 2022 and mes=3;
UPDATE yp_cas_assistance SET h4=SUBSTRING(h4,2, 9) WHERE h4 like '%-%' and anio = 2022 and mes=3;

SELECT /*DISTINCT*/ codigo_empresa, localidad, origen, transaccion, fila
FROM YP_CAS_DETTRANSACTION
group by codigo_empresa, localidad, origen, transaccion, fila
ORDER BY transaccion, fila

--PARA VER CARGOS EN VACACIONES
SELECT CODIGO, DESCRIPCION 
FROM yp_cva_position

--PARA VER CARGOS EN ROLES
SELECT CODIGO, NOMBRE, SUELDO
FROM yp_nom_charges
WHERE NOMBRE LIKE '%AVALUA%'
--WHERE CODIGO ='1412'

--PARA VER CARGOS EN ASISTENCIA DIFERENTE A VACACIONES
SELECT yp_nom_charges.CODIGO, yp_nom_charges.NOMBRE, yp_cva_position.CODIGO, yp_cva_position.DESCRIPCION 
FROM yp_nom_charges inner join yp_cva_position on  yp_nom_charges.CODIGO=yp_cva_position.CODIGO
WHERE yp_cva_position.DESCRIPCION != yp_nom_charges.NOMBRE

--PARA ACTUALIZAR CARGOS EN VACACIONES
--UPDATE yp_cva_position SET descripcion='CONTROLADOR OPERACIONAL. S-' WHERE codigo=1461;

--PARA ACTUALIZAR CARGOS EN ASISTENCIA
--UPDATE yp_nom_charges SET nombre='COMISARIO DE CONSTRUCCIONES', descripcion='COMISARIO DE CONSTRUCCIONES' 
--where codigo = 8;

--PARA INGRESAR CARGO
--INSERT INTO yp_cva_position (Codigo_Empresa, Localidad, Codigo, Descripcion, Enviado, Caucionado) 
--Values (15, 1, 1462, 'ANALISTA DE TALENTO HUMANO-EC', 0,0)


--PARA VER CONEXIONES A BDD EN TABLA AUDITORIA 
SELECT * 
FROM YP_AUDIT
WHERE FECHA BETWEEN '01/05/2020' AND '01/06/2020'
--AND EVENTO LIKE '%Adrian%'
--AND (USUARIO='ADMINISTRADOR' OR USUARIO='ZOILY' OR USUARIO='YUPAK')
--AND USUARIO <> 'LORENA'
ORDER BY FECHA

--PARA VER FUNCIONARIOS QUE SALIERON DE LA INSTITUCION Y EL PAGO ESTA EN 1
SELECT CEDULA, YP_NOM_EMPLOYEES.NOMBRE, YP_NOM_EMPLOYEES.REGLAMENTO
FROM YP_NOM_EMPLOYEES 
WHERE  YP_NOM_EMPLOYEES.PagoAutomatico = 1 and YEAR(YP_NOM_EMPLOYEES.FechaS)=2022 
ORDER BY YP_NOM_EMPLOYEES.NOMBRE

--PARA VER FUNCIONARIOS SIN REGLAMENTO o SIN TARJETA (LOSEP O CODIGO)
SELECT *--YP_NOM_EMPLOYEES.CODIGO, YP_NOM_EMPLOYEES.NOMBRE, YP_NOM_EMPLOYEES.TARJETA,REGLAMENTO, ROL
FROM YP_NOM_EMPLOYEES 
WHERE  YP_NOM_EMPLOYEES.PagoAutomatico = 1 AND REGLAMENTO='0' OR TARJETA=''

--PARA VER FUNCIONARIOS CON CODIGO Y TARJETA DIFERENTES
select codigo, tarjeta, nombre
from YP_NOM_EMPLOYEES 
where (tarjeta::text != codigo::text) and pagoautomatico='1'

--PARA VER ASISTENCIA
SELECT * 
FROM yp_cas_assistance 
WHERE FUNCIONARIO = 1460
AND YEAR(FECHA)=20
AND MONTH(FECHA)=01
AND DAY(FECHA)=30

--PARA VER EMPLEADOS CUYA FECHA DE SALIDA NO ES 01/01/1900 (aún trabajan en el muni)
SELECT *
FROM YP_NOM_EMPLOYEES 
WHERE codigo=2113 --CEDULA='1600586257'--YP_NOM_EMPLOYEES.fechas!='1900-01-01' AND PagoAutomatico=1 

--PARA VER EXCESOS DE TIEMPO DE MARCACIONES EN DEPURACIÓN
select funcionario, fecha, atraso, falta, h1, h2, h3, h4, horareferencia, hora, * 
from yp_cas_assistancetmp 
where funcionario = '2277' 
and day(cast(fecha as date)) = '01'
and month(cast(fecha as date)) = '06' 
and year(cast(fecha as date)) = '2022' --CAST(fecha AS DATE) = '2022-05-01 00:00:00'

--PARA LIMPIAR ERRORES BASURA EN DEPURACIÓN DE EXCESOS DE TIEMPO
SELECT * FROM YP_CAS_ASSISTANCETMP
where funcionario='929' 
and day(cast(fecha as date)) in (3,4,5,6,7,8,9,10) --'2022-05-13 00:00:00'
and month(cast(fecha as date)) = 5 
and year(cast(fecha as date)) = 2022 
--where h1 like '%-%' or h2 like '%-%' or h3 like '%-%' or h4 like '%-%' or atraso like '%-%' or falta like '%-%' 

Update YP_CAS_ASSISTANCETMP set H3='00:00:00' 
where h1 like '%-%' or h2 like '%-%' or h3 like '%-%' or h4 like '%-%' or atraso like '%-%' or falta like '%-%' 


--PARA VER REGISTROS DE MARCACIONES EN DEPURACION DE UN FUNCIONARIO
select * --funcionario, fecha, hora 
from yp_cas_assistancetmp 
where codigoreloj='2004' and DAY(fecha) IN (29,30)
ORDER BY FECHA, HORA

SELECT *
FROM YP_NOM_EMPLOYEES 
WHERE NOMBRE LIKE 'QUISHPI C%'


--PARA VER MARCACIONES DE UN FUNCIONARIO EN MES ESPECIFICO
select * 
from yp_cas_assistance 
inner join YP_NOM_EMPLOYEES ON YP_NOM_EMPLOYEES.codigo=yp_cas_assistance.funcionario   
WHERE YP_NOM_EMPLOYEES.nombre like 'BASTIDAS CORTES%'
AND year(yp_cas_assistance.fecha)='2021' and month(yp_cas_assistance.fecha)='12' --and funcionario='434'
order by fecha, hora

--PARA VER DATOS DE LA ORGANIZACIÓN BDD
select * from yp_organization

--PARA VER USUARIOS DE BDD
select * from yp_user

--PARA MATAR SESIONES
/*SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE datname = 'asis_gadmcp'
AND pid<> pg_backend_pid()*/

select * from yp_gaf_class --yp_gaf_type
where tipo=7 and subtipo=1
order by codigo

--PARA ACTUALIZAR RUC EN POLIZAS DE GARANTIAS
UPDATE YP_CG_WARRANTY SET Contratista = CONCAT(Contratista, '001') WHERE Numero LIKE '%709955%'

--PARA VER BIENES DE LARGA DURACIÓN EN ACT_GMCP 
SELECT *
FROM yp_gaf_documentasset --tabla de documento INGRESO
--from yp_gaf_assets --tabla que aparece con el f5
where numero_transaccion=3974 --codigo=3958
--WHERE Origen=0 and vidautil=0 and tipotransaccion='CI'

--PARA VER ACTA DE BLD Y BSC
SELECT * 
FROM YP_GAF_DET_DELIVERYCERTIF 
WHERE numero_acta = '15080' 
ORDER BY CODIGO

SELECT * 
FROM YP_GAF_DELIVERYCERTIF 
WHERE numero_acta = '15080' 


--PARA VER UN FUNCIONARIO
select *
FROM YP_NOM_EMPLOYEES
WHERE nombre like 'BARRENO% JO%' --codigo=1760 
ORDER BY NOMBRE

--PARA VER EN ASISTENCIA FUNCIONARIOS CON CARGOS
SELECT all YP_NOM_PROJECT.descripcion as "UNIDAD A LA QUE PERTENECE", YP_NOM_EMPLOYEES.nombre as "NOMBRE", 
YP_CVA_POSITION.DESCRIPCION as "PUESTO INSTITUCIONAL", FECHAI, FECHAS
FROM YP_NOM_EMPLOYEES 
inner join YP_NOM_PROJECT ON YP_NOM_EMPLOYEES.proyecto=YP_NOM_PROJECT.codigo   
inner join YP_CVA_POSITION ON YP_NOM_EMPLOYEES.cargo=YP_CVA_POSITION.codigo
where YP_NOM_EMPLOYEES.nombre LIKE 'BARRENO V%' 


--EN ESTA TABLA ESTÁN LOS CARGOS QUE SE IMPORTAN DESDE ROLES A ASISTENCIA VACACIONES
SELECT CODIGO, DESCRIPCION
FROM YP_CVA_POSITION
ORDER BY CODIGO

--PARA VER CARGOS EN ROLES, APUNTAR A BDD ROLES
SELECT CODIGO, NOMBRE
FROM YP_NOM_CHARGES
WHERE CODIGO = 1081
ORDER BY CODIGO

SELECT all YP_NOM_EMPLOYEES.nombre as "NOMBRE", YP_NOM_CHARGES.descripcion as "PUESTO INSTITUCIONAL", 
YP_NOM_PROJECT.descripcion as "UNIDAD A LA QUE PERTENECE", YP_NOM_EMPLOYEES.DireccionT as "DIRECCION INSTITUCIONAL", 
YP_NOM_EMPLOYEES.CiudadT as "CIUDAD", YP_NOM_EMPLOYEES.TelefonoT AS "TELEFONO", '200' AS "EXTENSION", YP_NOM_EMPLOYEES.MAIL AS "MAIL"
FROM YP_NOM_EMPLOYEES 
inner join YP_NOM_PROJECT ON YP_NOM_EMPLOYEES.proyecto=YP_NOM_PROJECT.codigo   
inner join YP_NOM_CHARGES ON YP_NOM_EMPLOYEES.cargo=YP_NOM_CHARGES.codigo
WHERE YP_NOM_CHARGES.codigo=1081


--PARA BIOMETRICOS

SELECT CODIGO, CEDULA, NOMBRE, MAIL, PAGOAUTOMATICO
/*SELECT **/ 
FROM YP_NOM_EMPLOYEES
WHERE PagoAutomatico=1 
ORDER BY NOMBRE

--PARA TRABAJO SOCIAL
--POSTGRES
SELECT CEDULA, NOMBRE, COALESCE(FECHAN,'1900-01-01') as FECHAN, COALESCE(FECHAI,'1900-01-01') AS FECHAI, 
COALESCE(FECHAS,'1900-01-01') AS FECHAS, COALESCE(FECHAR,'1900-01-01') AS FECHAR, cast(CODIGO as int4)
FROM YP_NOM_EMPLOYEES 
ORDER BY NOMBRE

--SQL
SELECT CEDULA, NOMBRE, cast(FECHAN AS date) as FECHANAC, cast(YP_NOM_EMPLOYEES.FECHAI AS DATE) AS FECHAING, 
cast(YP_NOM_EMPLOYEES.FECHAS AS DATE) AS FECHASAL, cast(YP_NOM_EMPLOYEES.FECHAR AS DATE) AS FECHAREI, CAST(CODIGO AS INT) AS COD 
FROM YP_NOM_EMPLOYEES 
ORDER BY NOMBRE

--PARA VER FUNCIONARIOS QUE INGRESARON O REINTEGRARON O SALIERON EN MES ESPECIFICO

SELECT YP_NOM_EMPLOYEES.CEDULA, YP_NOM_EMPLOYEES.NOMBRE, YP_NOM_CHARGES.nombre, '' AS TIPO, 
cast(YP_NOM_EMPLOYEES.FECHAI as date)AS FECHAI, cast(YP_NOM_EMPLOYEES.FECHAR as date)AS FECHAR, cast(YP_NOM_EMPLOYEES.FECHAS as date)AS FECHAS
FROM YP_NOM_EMPLOYEES 
inner join YP_NOM_CHARGES ON YP_NOM_EMPLOYEES.cargo=YP_NOM_CHARGES.codigo
WHERE (YEAR(YP_NOM_EMPLOYEES.FECHAI)=2022 AND MONTH(YP_NOM_EMPLOYEES.FECHAI)=5) 
OR (YEAR(YP_NOM_EMPLOYEES.FECHAR)=2022 AND MONTH(YP_NOM_EMPLOYEES.FECHAR)=5)
OR (YEAR(YP_NOM_EMPLOYEES.FECHAS)=2022 AND MONTH(YP_NOM_EMPLOYEES.FECHAS)=5)

--PARA CONTAR FUNCIONARIOS POR TIPO DE ROL
SELECT ROL, COUNT(ROL) AS TOTAL --YP_NOM_EMPLOYEES.CODIGO, YP_NOM_EMPLOYEES.NOMBRE, YP_NOM_EMPLOYEES.TARJETA
FROM YP_NOM_EMPLOYEES 
WHERE  YP_NOM_EMPLOYEES.PagoAutomatico = 1 AND fechai< '01/02/2022'
GROUP BY ROL

--PARA VER NOMBRES DE JORNADAS DE UN FUNCIONARIO
select yp_cas_schedulexf.funcionario, yp_nom_employees.nombre, yp_cas_schedulexf.fechai, yp_cas_schedulexf.fechaf, yp_cas_schedulexf.jornada, 
yp_cas_workingday.descripcion, yp_cas_workingday.fechai, yp_cas_workingday.fechaf
from yp_cas_schedulexf 
inner join yp_cas_workingday on yp_cas_schedulexf.jornada=yp_cas_workingday.codigo
inner join yp_nom_employees on yp_nom_employees.codigo=yp_cas_schedulexf.funcionario
where /*yp_cas_schedulexf.funcionario=1338*/ yp_nom_employees.nombre like 'ESPIN TERAN MARIO IVAN%'

--PARA VER JORNADAS DE UN FUNCIONARIO
select * 
from yp_cas_schedulexf
where funcionario=2101
order by fechai

--PARA VER LAS JORNADAS
select * from yp_cas_workingday 
where codigo=8

--PARA VER REGISTROS QUE YA ESTAN EN EXTRAS DESPUES DE MARCACIONES INTEGRAS
SELECT * 
FROM YP_CAS_ASSISTANCETMP
WHERE depurado=33 and codigoreloj='2066'
ORDER BY fecha, hora

--PARA ACTUALIZAR REGLAMENTO CON TIPO ROLES
update YP_NOM_EMPLOYEES set Reglamento=2 where rol in (2,4) and PagoAutomatico=1;
update YP_NOM_EMPLOYEES set Reglamento=1 where rol in (1,3) and PagoAutomatico=1;

select distinct Rol, CASE Reglamento WHEN 1 then 'LOSEP' else 'CODIGO T' end
,Count(*) from YP_NOM_EMPLOYEES where PagoAutomatico=1 group by Rol, Reglamento order by 1