-- Purpose: Demonstrates reusable PL/SQL procedures and functions.
-- Use: Encapsulate logic for updates and reusable calculations.
-- Procedure and function example
CREATE OR REPLACE PROCEDURE add_bonus(p_employee_id IN NUMBER, p_bonus IN NUMBER) IS
BEGIN
    UPDATE employees
    SET salary = salary + p_bonus
    WHERE employee_id = p_employee_id;
END;
/

CREATE OR REPLACE FUNCTION get_bonus_amount(p_salary NUMBER) RETURN NUMBER IS
BEGIN
    RETURN p_salary * 0.10;
END;
/
