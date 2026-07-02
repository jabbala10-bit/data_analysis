-- Purpose: Shows how to declare variables and use common PL/SQL data types.
-- Use: Practice assigning values and formatting output.
-- Variables and datatypes
DECLARE
    v_number NUMBER := 100;
    v_text VARCHAR2(50) := 'Oracle';
    v_date DATE := SYSDATE;
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_number || ' - ' || v_text || ' - ' || v_date);
END;
/
