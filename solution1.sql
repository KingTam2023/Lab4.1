spool solution1
set echo on
set feedback on
set linesize 300
set pagesize 200

/* (1) First, the script inserts information about a new bank account. All information about a new account is up to you.
       The script must make an insertion permanent in a database.                                                        */

INSERT INTO ACCOUNT VALUES (1234567890, 'National Banco do Brasil', 0.0, 'savings' );
COMMIT;

/* (2) Next, the script lists information about the new bank account created in the previous step.                       */

SELECT * 
FROM ACCOUNT
WHERE account_num = 1234567890 AND
      bank_name = 'National Banco do Brasil';

/* (3) Next, the script creates a database trigger, that updates a balance of a bank account each time a new transaction 
       is recorded in a database. A type of a database trigger is up to you.                                             */

CREATE OR REPLACE TRIGGER solution1

BEFORE INSERT ON TRANSACTION

FOR EACH ROW

BEGIN
  IF (:NEW.type = 'deposit' ) THEN
    UPDATE ACCOUNT
    SET balance = balance + :NEW.amount
    WHERE account_num = :NEW.acc_num AND
          bank_name = :NEW.bank_name;
  ELSE
    UPDATE ACCOUNT
    SET balance = balance - :NEW.amount
    WHERE account_num = :NEW.acc_num AND
          bank_name = :NEW.bank_name;
  END IF;
END;
/

/* (4) Next, the script comprehensively tests the trigger. A test must include at least one new transaction of each type 
       (deposit, withdrawal)  operating on a bank account created in a step (1) and it must list a balance of the bank 
       account each time new transaction is recorded in a database. Insertion of each new transaction must be permanently 
       recorded in a database.                                                                                           */

INSERT INTO TRANSACTION VALUES (1234567890, 'National Banco do Brasil', sysdate-1, 600, 'deposit');
COMMIT;

SELECT * 
FROM ACCOUNT
WHERE account_num = 1234567890 AND
      bank_name = 'National Banco do Brasil';

INSERT INTO TRANSACTION VALUES (1234567890, 'National Banco do Brasil', sysdate, 100, 'withdrawal');
COMMIT;

SELECT * 
FROM ACCOUNT
WHERE account_num = 1234567890 AND
      bank_name = 'National Banco do Brasil';

/* (5) Finally, the script removes from a data dictionary a trigger created in a step (3).                             */

DROP TRIGGER solution1;

spool off




