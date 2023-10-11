SPOOL solution2
SET SERVEROUTPUT ON
SET ECHO ON
SET FEEDBACK ON
SET LINESIZE 200
SET PAGESIZE 400

/* (1) First, the script removes a domain constraint, that enforces a value of an account balance (column balance)
        to be greater or equal to zero in a relational table ACCOUNT.                                                 */

ALTER TABLE ACCOUNT DROP CONSTRAINT ACCOUNT_CHK1;

/* (2) Next, the script inserts into a database information about four accounts, such that the first two accounts
       are located in the same bank and the next two accounts are located in another bank. The values in a column 
       balance must be negative and such that the total negative balance on the accounts located in the same bank 
       cannot be less that -100. All other values are up to you. The sample values of balance are listed below.       

       ACCOUNT
        number     bank     balance   ... 
          1         A         -80     ...
          2         A         -20     ...
          1         B         -50     ...
          2         B         -30     ...

        Information inserted in this step must be permanently recorded in a sample database.                         */

INSERT INTO ACCOUNT VALUES (1234567891, 'National Banco do Brasil', -50.0, 'savings' );
INSERT INTO ACCOUNT VALUES (1234567892, 'National Banco do Brasil', -50.0, 'savings' );
INSERT INTO ACCOUNT VALUES (1234567891, 'National Fuji Bank', -50.0, 'savings' );
INSERT INTO ACCOUNT VALUES (1234567892, 'National Fuji Bank', -30.0, 'savings' );
COMMIT;

/* (3) Next, the script lists information inserted in the previous step.                                             */

SELECT * 
FROM ACCOUNT
WHERE account_num IN (1234567891,1234567892 ) AND 
      bank_name IN ('National Banco do Brasil', 'National Fuji Bank')
ORDER BY bank_name, account_num;

/* (4) Next, the script implements a database trigger (a type of a trigger is up to you), that enforces 
       the following domain constraint.

       The total value of balance on all bank accounts located in a bank and such that the balance of the accounts 
       is negative, cannot be less than -100.

       For example, consider the accounts listed in a step (2) above. It is impossible to withdraw any money from 
       the accounts 1 and 2 in a bank A because the total balance on the accounts 1 and 2 in bank A is negative and 
       it is equal to -100. 

       However, it is still possible to withdraw 20 from one of the accounts 1 and 2 (or 10 from each) in a bank B 
       because the total balance on the accounts 1 and 2 in a bank B is negative and it is equal to -80. After 
       withdrawal of 20 from an account 2 in a bank B the total balance on the accounts 1 and 2 in bank will be 
       equal -100 (-50 + -50) and it still does not violate the new domain constraint.                              */

CREATE OR REPLACE TRIGGER solution2

AFTER UPDATE OF balance ON ACCOUNT

DECLARE
  bname ACCOUNT.bank_name%type;

BEGIN

  SELECT bank_name
  INTO bname
  FROM ACCOUNT
  WHERE balance < 0
  GROUP BY bank_name
  HAVING SUM(balance) < -100;

  RAISE_APPLICATION_ERROR(-20001,'Total amount of negative balances cannot be less than 100');

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20001,'Total value of negative balances cannot be less than 100');
END;
/

show errors

/* (4) Next, the script comprehensively tests the trigger. The tests must include the operations on the bank 
       accounts created in a step (2) only. A single test is an UPDATE statement, that attempts to change a balance 
       on a bank account. At least two tests are required. Both tests must withdraw money from a bank account. 
       The first test must fail the new domain constraint and the second test must pass the new domain constraint. 
       The sample withdrawals from the bank accounts are explained in a step (4). A state of all four bank accounts 
       must be listed after each test.                                                                              */

UPDATE ACCOUNT
SET balance = balance - 1
WHERE account_num = 1234567891 AND
      bank_name = 'National Banco do Brasil';
COMMIT;

SELECT * 
FROM ACCOUNT
WHERE account_num IN (1234567891,1234567892 ) AND 
      bank_name IN ('National Banco do Brasil', 'National Fuji Bank')
ORDER BY bank_name, account_num;

UPDATE ACCOUNT
SET balance = balance - 20
WHERE account_num = 1234567891 AND
      bank_name = 'National Fuji Bank';
COMMIT;

SELECT * 
FROM ACCOUNT
WHERE account_num IN (1234567891,1234567892 ) AND 
      bank_name IN ('National Banco do Brasil', 'National Fuji Bank')
ORDER BY bank_name, account_num;

/* (5) Finally, the script removes from a data dictionary a trigger created in a step (3).                          */

DROP TRIGGER solution2;

spool off
