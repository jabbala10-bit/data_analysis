-- Purpose: Demonstrates bulk processing for better performance.
-- Use: Fetch many rows efficiently into memory.
-- Bulk processing example
DECLARE
    TYPE t_emp_ids IS TABLE OF employees.employee_id%TYPE;
    v_ids t_emp_ids;
BEGIN
    SELECT employee_id BULK COLLECT INTO v_ids
    FROM employees
    WHERE department_id = 30;

    FOR i IN 1..v_ids.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(v_ids(i));
    END LOOP;
END;
/
