-- Purpose: Introduces packages for modular PL/SQL design.
-- Use: Group procedures and support reusable logging logic.
-- Package specification and body example
CREATE OR REPLACE PACKAGE audit_pkg AS
    PROCEDURE log_event(p_event_name VARCHAR2);
END audit_pkg;
/

CREATE OR REPLACE PACKAGE BODY audit_pkg AS
    PROCEDURE log_event(p_event_name VARCHAR2) IS
    BEGIN
        INSERT INTO audit_log(event_name, event_time)
        VALUES (p_event_name, SYSDATE);
    END;
END audit_pkg;
/
