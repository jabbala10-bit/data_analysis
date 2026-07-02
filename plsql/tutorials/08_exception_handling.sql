-- Purpose: Shows how to handle runtime errors gracefully.
-- Use: Catch exceptions such as divide-by-zero conditions.
-- Exception handling
DECLARE
    v_dividend NUMBER := 10;
    v_divisor NUMBER := 0;
    v_result NUMBER;
BEGIN
    v_result := v_dividend / v_divisor;
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Division by zero is not allowed.');
END;
/
