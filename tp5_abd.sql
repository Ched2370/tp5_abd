USE hr;
/*
1. Por motivos presupuestarios, el departamento de recursos
humanos necesita un informe que muestre los apellidos, la
descripción de la tarea que realizan, la ciudad en la que trabajan y
el salario de los empleados que ganan más de 12.000 dólares.
*/
DROP VIEW IF EXISTS informe_1;
CREATE VIEW informe_1 AS
SELECT
    e.last_name AS apellido,
    j.job_title AS descripcion,
    l.city AS ciudad,
    e.salary AS salario
FROM
    employees e
    INNER JOIN jobs j ON e.job_id = j.job_id
    INNER JOIN departments d ON e.department_id = d.department_id
    INNER JOIN locations l ON d.location_id = l.location_id
WHERE
    e.salary > 12000;

/*
2. Cree un informe que muestre el nombre y apellido, sueldo anual
incluida comisión si la cobran y departamento de los empleados
que desempeñan sus tareas en Europa.
*/

DROP VIEW IF EXISTS informe_2;

CREATE VIEW informe_2 AS
SELECT 
    e.first_name AS nombre, 
    e.last_name AS apellido,
    e.salary AS salario, 
    ROUND(
        (e.salary * IF(e.commission_pct IS NOT NULL, e.commission_pct + 1, 1)) * 12
    ) AS sueldo_anual,
    d.department_name AS departamento
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN locations l ON d.location_id = l.location_id
INNER JOIN countries c ON c.country_id = l.country_id 
INNER JOIN regions r ON c.region_id = r.region_id
WHERE r.region_name = "Europe";

/*
3. Cree un informe para mostrar el nombre y apellido, el puesto y la
fecha de inicio para los empleados con los apellidos que contienen
las letras <<a>> y <<b>>. Ordene la consulta por orden
ascendente por fecha de inicio.
*/
DROP VIEW IF EXISTS informe_3;
CREATE VIEW informe_3 AS
SELECT 
    e.first_name AS nombre,
    e.last_name AS apellido,
    j.job_title AS puesto,
    jh.start_date AS fecha_de_inicio
FROM
  employees e
INNER JOIN jobs j ON e.job_id = j.job_id
INNER JOIN job_history jh ON e.employee_id = jh.employee_id
WHERE e.last_name LIKE '%a%' OR e.last_name LIKE '%b%'
ORDER BY jh.start_date; 

/*
4. Encuentre el apellido, correo electrónico, teléfono y el salario de
los empleados que ganan entre 5.000 y 12.000 dólares, están en
el departamento Ventas y han sido contratados en 1994. Etiquete
las columnas como Empleado, E-mail, Teléfono y Sueldo,
respectivamente.
*/
DROP VIEW IF EXISTS informe_4;
CREATE VIEW informe_4 AS
SELECT 
  e.last_name AS apellido,
  e.email AS correo_electronico,
  e.phone_number AS telefono,
  e.salary AS salario
FROM employees e 
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN job_history jh ON e.employee_id = jh.employee_id
WHERE (e.salary >= 5000 AND e.salary <= 12000)
AND d.department_name LIKE "Sales"
AND (jh.start_date > "1993-12-31" AND jh.start_date < "1995-01-01");

/* UPDATE job_history jh
SET jh.start_date = "1994-01-13"
WHERE jh.employee_id = 176 AND jh.start_date = "1998-03-24"; */

/*
5. Cree un informe que muestre el apellido, el salario y la comisión
de todos los empleados que ganen comisiones. Ordene los datos
en orden descendente por salario y comisiones.
*/
DROP VIEW IF EXISTS informe_5;
CREATE VIEW informe_5 AS 
SELECT
  e.last_name AS apellido,
  e.salary AS salario,
  e.commission_pct AS comision
FROM employees e
WHERE e.commission_pct > 0
ORDER BY e.salary DESC, e.commission_pct DESC;

/*
6. Muestre el apellido, el puesto de trabajo y el salario de todos los
empleados que sean representante de ventas o administrativo y
cuyo salario sea distinto de 2.500, 3.500 ó 7.000 dólares.
*/
DROP VIEW IF EXISTS informe_6;
CREATE VIEW informe_6 AS
SELECT
  e.last_name AS apellido,
  j.job_title AS puesto,
  e.salary AS salario
FROM employees e
INNER JOIN jobs j ON e.job_id = j.job_id
WHERE 
(j.job_title LIKE "Sales Representative" 
OR j.job_title LIKE "Administration%")
AND e.salary <> 2500
AND e.salary <> 3500
AND e.salary <> 7000;

/*
7. Mostrar el apellido, el salario y la comisión de todos los empleados
cuyo importe de comisión sea de más del 20% de los ingresos
anuales de CEO de la empresa.
*/
DROP VIEW IF EXISTS informe_7;
CREATE VIEW informe_7 AS
SELECT
  e.last_name AS apellido,
  e.salary AS salario,
  e.commission_pct AS comision
FROM employees e
INNER JOIN jobs j ON e.job_id = j.job_id
WHERE (e.commission_pct * e.salary) > 
(SELECT (e2.salary * 0.2)
FROM employees e2 
INNER JOIN jobs j2 ON e2.job_id = j2.job_id
WHERE j2.job_title LIKE "President") * 12;

/* UPDATE employees e
SET e.commission_pct = 5
WHERE e.last_name LIKE "Russell"; */

