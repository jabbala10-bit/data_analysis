-- Purpose: Shows how to store values using collections.
-- Use: Practice working with arrays of data in memory.
-- Records and collections
DECLARE
    TYPE t_numbers IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    v_nums t_numbers;
BEGIN
    v_nums(1) := 10;
    v_nums(2) := 20;
    v_nums(3) := 30;
    FOR i IN 1..v_nums.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(v_nums(i));
    END LOOP;
END;
/
