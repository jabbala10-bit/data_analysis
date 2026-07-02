-- Purpose: Introduces explicit cursors for row-by-row processing.
-- Use: Iterate through query results safely and clearly.
-- Explicit cursor example
DECLARE
    CURSOR c_emp IS
        SELECT employee_id, first_name
        FROM employees
        WHERE rownum <= 5;
BEGIN
    FOR r_emp IN c_emp LOOP
        DBMS_OUTPUT.PUT_LINE(r_emp.employee_id || ' - ' || r_emp.first_name);
    END LOOP;
END;
/
