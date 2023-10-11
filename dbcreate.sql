/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
CREATE TABLE BANK(
 bank_name     VARCHAR(50)  NOT NULL,  /* Bank name                                                   */
 hq_country    VARCHAR(30)  NOT NULL,  /* Country part of headquarters address                        */
 hq_city       VARCHAR(30)  NOT NULL,  /* City part of headquarters address                           */
 hq_street     VARCHAR(30)  NOT NULL,  /* Street part of headquarters address                         */
 hq_bldg_num   NUMBER(4)    NOT NULL,  /* Building number part of headquarters address                */
 web_site      VARCHAR(200) NOT NULL,  /* Link to Web site                                            */
 email         VARCHAR(100) NOT NULL,  /* Email address                                               */
 bank_type     VARCHAR(30)      NULL,  /* Bank type                                                   */
  CONSTRAINT BANK_PK PRIMARY KEY (bank_name),
  CONSTRAINT BANK_CK1 UNIQUE (hq_country, hq_city, hq_street, hq_bldg_num),
  CONSTRAINT BANK_CK2 UNIQUE (web_site),
  CONSTRAINT BANK_CK3 UNIQUE (email),
  CONSTRAINT BANK_CHECK CHECK (bank_type IN ('investment', 'commercial', 'central', 'agriculture', 
                                                                     'construction', 'industrial') ) );

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

CREATE TABLE BRANCH(
  bank_name     VARCHAR(50)  NOT NULL, /* Bank name                                                    */
  br_name       VARCHAR(50)  NOT NULL, /* Branch name                                                  */
  br_country    VARCHAR(30)  NOT NULL, /* Country part of branch address                               */
  br_city       VARCHAR(30)  NOT NULL, /* City part of branch address                                  */
  br_street     VARCHAR(30)  NOT NULL, /* Street part of branch address                                */
  br_bldg_num   NUMBER(4)    NOT NULL, /* Building number part of branch address                       */
  total_emps    NUMBER(3)        NULL, /* Total number of employees at a branch                        */
   CONSTRAINT BRANCH_PK PRIMARY KEY (bank_name, br_name, br_country, br_city),
   CONSTRAINT BRANCH_CK1 UNIQUE (br_country, br_city, br_street, br_bldg_num),
   CONSTRAINT BRANCH_FK1 FOREIGN KEY (bank_name) REFERENCES BANK(bank_name) );

 /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

 CREATE TABLE EMPLOYEE(
  emp_num       NUMBER(7)   NOT NULL,  /* Employee number                                              */
  first_name    VARCHAR(20)      NULL, /* Employee first name                                          */
  last_name     VARCHAR(20)  NOT NULL, /* Employee last name                                           */
  date_of_birth DATE         NOT NULL, /* Date of birth                                                */
  position      VARCHAR(100) NOT NULL, /* Position occupied                                            */
  bank_name     VARCHAR(50)  NOT NULL, /* Bank name                                                    */
  br_name       VARCHAR(50)      NULL, /* Branch name                                                  */
  br_country    VARCHAR(30)      NULL, /* Country location of a branch                                 */
  br_city       VARCHAR(30)      NULL, /* City location of a branch                                    */
   CONSTRAINT EMPLOYEE_PK PRIMARY KEY (bank_name, emp_num),
   CONSTRAINT EMPLOYEE_FK1 FOREIGN KEY (bank_name, br_name, br_country, br_city)
               REFERENCES BRANCH(bank_name, br_name, br_country, br_city) );
 
/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

CREATE TABLE ACCOUNT(
 account_num   NUMBER(10)  NOT NULL,   /* Account number                                               */
 bank_name     VARCHAR(50) NOT NULL,   /* Bank name                                                    */
 balance       NUMBER(9,2) NOT NULL,   /* Account balance                                              */
 account_type  VARCHAR(8)  NOT NULL,   /* Account type: savings, checking, loan                        */
  CONSTRAINT ACCOUNT_PK PRIMARY KEY (account_num, bank_name),
  CONSTRAINT ACCOUNT_FK1 FOREIGN KEY (bank_name) REFERENCES BANK(bank_name),
  CONSTRAINT ACCOUNT_CHK1 CHECK( balance >= 0 ),
  CONSTRAINT ACCOUNT_CHK2 CHECK( account_type IN ('savings','checking','loan') ) );
 
/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

CREATE TABLE TRANSACTION(
 acc_num       NUMBER(10)  NOT NULL,  /* Account number                                                */
 bank_name     VARCHAR(50) NOT NULL,  /* Bank name                                                     */
 tr_date_time  DATE        NOT NULL,  /* Transaction date                                              */
 amount        NUMBER(7,2) NOT NULL,  /* Amount involved                                               */
 type          VARCHAR(10) NOT NULL,  /* Transaction type                                              */
  CONSTRAINT TRANSACTION_PK PRIMARY KEY(acc_num, bank_name, tr_date_time),
  CONSTRAINT TRANSACTION_FK2 FOREIGN KEY(acc_num, bank_name) REFERENCES ACCOUNT(account_num, bank_name),
  CONSTRAINT TRANSACTION_CHK1 CHECK( amount >= 0 ),
  CONSTRAINT TRANSACTION_CHK2 CHECK( type IN ('deposit', 'withdrawal' ) ) );     
 
/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */ 
/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

