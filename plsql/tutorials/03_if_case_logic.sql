-- Purpose: Demonstrates branching with IF and CASE logic.
-- Use: Apply simple business rules such as score bands or risk flags.
-- IF and CASE logic
DECLARE
    v_score NUMBER := 78;
BEGIN
    IF v_score >= 90 THEN
        DBMS_OUTPUT.PUT_LINE('Excellent');
    ELSIF v_score >= 70 THEN
        DBMS_OUTPUT.PUT_LINE('Good');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Needs improvement');
    END IF;
END;
/
