-- Purpose: Introduces a minimal anonymous PL/SQL block.
-- Use: Learn how to print output and execute a basic block.
-- Basic PL/SQL block
DECLARE
    v_message VARCHAR2(100) := 'Hello PL/SQL';
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_message);
END;
/
