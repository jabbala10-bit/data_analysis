-- Purpose: Explains how loops repeat logic in PL/SQL.
-- Use: Practice iteration over a range of values.
-- Loops and iterations
DECLARE
    v_counter NUMBER := 1;
BEGIN
    WHILE v_counter <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE('Counter: ' || v_counter);
        v_counter := v_counter + 1;
    END LOOP;
END;
/
