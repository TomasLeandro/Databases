select 'drop, create, use database, create tables, display data:' as '';
do sleep(5);


-- Schema tlm16g
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `tlm16g` ;

-- -----------------------------------------------------
-- Schema tlm16g
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `tlm16g` DEFAULT CHARACTER SET utf8 ;
USE `tlm16g` ;

-- -----------------------------------------------------
-- Table `tlm16g`.`person`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `person` ;

CREATE TABLE IF NOT EXISTS `tlm16g`.`person` (
  `per_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `per_ssn` BINARY(64) NULL,
  `per_fname` VARCHAR(15) NOT NULL,
  `per_lname` VARCHAR(45) NOT NULL,
  `per_street` VARCHAR(30) NOT NULL,
  `per_city` VARCHAR(30) NOT NULL,
  `per_state` CHAR(2) NOT NULL,
  `per_zip` INT(9) UNSIGNED ZEROFILL NOT NULL,
  `per_email` VARCHAR(100) NOT NULL,
  `per_dob` DATE NOT NULL,
  `per_type` ENUM('a', 'c', 'j') NOT NULL,
  `per_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`per_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tlm16g`.`phone`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tlm16g`.`phone` ;

CREATE TABLE IF NOT EXISTS `tlm16g`.`phone` (
  `phn_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `per_id` SMALLINT UNSIGNED NOT NULL,
  `phn_num` BIGINT UNSIGNED NOT NULL,
  `phn_type` ENUM('home,cell,work,fax') NOT NULL,
  `phn_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`phn_id`),
  INDEX `fk_phone_person_idx` (`per_id` ASC),
  CONSTRAINT `fk_phone_person`
    FOREIGN KEY (`per_id`)
    REFERENCES `tlm16g`.`person` (`per_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tlm16g`.`attorney`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tlm16g`.`attorney` ;

CREATE TABLE IF NOT EXISTS `tlm16g`.`attorney` (
  `per_id` SMALLINT UNSIGNED NOT NULL,
  `aty_start_date` DATE NOT NULL,
  `aty_end_date` DATE NOT NULL,
  `aty_hourly_rate` DECIMAL(5,2) UNSIGNED NOT NULL,
  `aty_years_in_practice` TINYINT NOT NULL,
  `aty_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`per_id`),
  CONSTRAINT `fk_attorney_person1`
    FOREIGN KEY (`per_id`)
    REFERENCES `tlm16g`.`person` (`per_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tlm16g`.`bar`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tlm16g`.`bar` ;

CREATE TABLE IF NOT EXISTS `tlm16g`.`bar` (
  `bar_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `per_id` SMALLINT UNSIGNED NOT NULL,
  `bar_name` VARCHAR(45) NOT NULL,
  `bar_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`bar_id`),
  INDEX `fk_bar_attorney1_idx` (`per_id` ASC),
  CONSTRAINT `fk_bar_attorney1`
    FOREIGN KEY (`per_id`)
    REFERENCES `tlm16g`.`attorney` (`per_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tlm16g`.`specialty`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tlm16g`.`specialty` ;

CREATE TABLE IF NOT EXISTS `tlm16g`.`specialty` (
  `src_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `per_id` SMALLINT UNSIGNED NOT NULL,
  `spc_type` VARCHAR(45) NOT NULL,
  `spc_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`src_id`),
  INDEX `fk_specialty_attorney1_idx` (`per_id` ASC),
  CONSTRAINT `fk_specialty_attorney1`
    FOREIGN KEY (`per_id`)
    REFERENCES `tlm16g`.`attorney` (`per_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tlm16g`.`client`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tlm16g`.`client` ;

CREATE TABLE IF NOT EXISTS `tlm16g`.`client` (
  `per_id` SMALLINT UNSIGNED NOT NULL,
  `cli_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`per_id`),
  CONSTRAINT `fk_client_person1`
    FOREIGN KEY (`per_id`)
    REFERENCES `tlm16g`.`person` (`per_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tlm16g`.`court`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tlm16g`.`court` ;

CREATE TABLE IF NOT EXISTS `tlm16g`.`court` (
  `crt_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `crt_name` VARCHAR(45) NOT NULL,
  `crt_street` VARCHAR(30) NOT NULL,
  `crt_city` VARCHAR(30) NOT NULL,
  `crt_state` CHAR(2) NOT NULL,
  `crt_zip` INT(9) UNSIGNED ZEROFILL NOT NULL,
  `crt_phone` BIGINT NOT NULL,
  `crt_email` VARCHAR(100) NOT NULL,
  `crt_url` VARCHAR(100) NOT NULL,
  `crt_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`crt_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tlm16g`.`judge`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tlm16g`.`judge` ;

CREATE TABLE IF NOT EXISTS `tlm16g`.`judge` (
  `per_id` SMALLINT UNSIGNED NOT NULL,
  `crt_id` TINYINT UNSIGNED NULL,
  `jud_salary` DECIMAL(8,2) NOT NULL,
  `jud_years_in_practice` TINYINT NOT NULL,
  `jud_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`per_id`),
  INDEX `fk_judge_court_idx` (`crt_id` ASC),
  CONSTRAINT `fk_judge_person1`
    FOREIGN KEY (`per_id`)
    REFERENCES `tlm16g`.`person` (`per_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_judge_court1`
    FOREIGN KEY (`crt_id`)
    REFERENCES `tlm16g`.`court` (`crt_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tlm16g`.`case`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tlm16g`.`case` ;

CREATE TABLE IF NOT EXISTS `tlm16g`.`case` (
  `cse_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `per_id` SMALLINT UNSIGNED NOT NULL,
  `cse_type` VARCHAR(45) NOT NULL,
  `cse_description` TEXT NOT NULL,
  `cse_start_date` DATE NOT NULL,
  `cse_end_date` DATE NULL,
  `cse_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`cse_id`),
  INDEX `fk_case_judge1_idx` (`per_id` ASC),
  CONSTRAINT `fk_case_judge1`
    FOREIGN KEY (`per_id`)
    REFERENCES `tlm16g`.`judge` (`per_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tlm16g`.`assignment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tlm16g`.`assignment` ;

CREATE TABLE IF NOT EXISTS `tlm16g`.`assignment` (
  `asn_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `per_cid` SMALLINT UNSIGNED NOT NULL,
  `per_aid` SMALLINT UNSIGNED NOT NULL,
  `cse_id` SMALLINT UNSIGNED NOT NULL,
  `asn_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`asn_id`),
  INDEX `fk_assignment_client1_idx` (`per_cid` ASC),
  INDEX `fk_assignment_attorney1_idx` (`per_aid` ASC),
  INDEX `fk_assignment_case1_idx` (`cse_id` ASC),

  CONSTRAINT `fk_assignment_client1`
    FOREIGN KEY (`per_cid`)
    REFERENCES `tlm16g`.`client` (`per_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assignment_attorney1`
    FOREIGN KEY (`per_aid`)
    REFERENCES `tlm16g`.`attorney` (`per_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assignment_case1`
    FOREIGN KEY (`cse_id`)
    REFERENCES `tlm16g`.`case` (`cse_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tlm16g`.`judge_hist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tlm16g`.`judge_hist` ;

CREATE TABLE IF NOT EXISTS `tlm16g`.`judge_hist` (
  `jhs_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `per_id` SMALLINT UNSIGNED NOT NULL,
  `jhs_crt_id` TINYINT UNSIGNED NULL,
  `jhs_date` TIMESTAMP NOT NULL,
  `jhs_type` ENUM('i', 'u', 'd') NOT NULL,
  `jhs_salary` DECIMAL(8,2) NOT NULL,
  `jhs_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`jhs_id`),
  INDEX `fk_judge_hist_judge1_idx` (`per_id` ASC),
  CONSTRAINT `fk_judge_hist_judge1`
    FOREIGN KEY (`per_id`)
    REFERENCES `tlm16g`.`judge` (`per_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

START TRANSACTION;

INSERT INTO assignment
(asn_id, per_cid, per_aid, cse_id, asn_notes)
VALUES
(NULL, 1, 6, 7, NULL),
(NULL, 2, 6, 6, NULL),
(NULL, 3, 7, 2, NULL),
(NULL, 4, 8, 2, NULL),
(NULL, 5, 9, 5, NULL),
(NULL, 1, 10, 1, NULL),
(NULL, 2, 6, 3, NULL),
(NULL, 3, 7, 8, NULL),
(NULL, 4, 8, 8, NULL),
(NULL, 5, 9, 8, NULL),
(NULL, 4, 10, 4, NULL);
COMMIT;


START TRANSACTION;

INSERT INTO client
(per_id, cli_notes)
VALUES
(1,NULL),
(2, NULL),
(3, NULL),
(4, NULL),
(5, NULL);

COMMIT;

START TRANSACTION;

INSERT INTO attorney
(per_id, aty_start_date, aty_end_date, aty_hourly_rate, aty_years_in_practice, aty_notes)
VALUES
(6, '2006-06-12', NULL, 85, 5, NULL),
(7, '2003-08-20', NULL, 130, 28, NULL),
(8, '2009-12-12', NULL, 70, 17, NULL),
(9, '2008-06-08', NULL, 78, 13, NULL),
(10, '2011-09-12', NULL, 60, 24, NULL);

COMMIT;


START TRANSACTION;

INSERT INTO bar
(bar_id, per_id, bar_name, bar_notes)
VALUES
(NULL, 6, 'Florida bar', NULL),
(NULL, 7, 'Alabama bar', NULL),
(NULL, 8, 'Georgia bar', NULL),
(NULL, 9, 'Michigan bar', NULL),
(NULL, 10, 'South Carolina bar', NULL),
(NULL, 6, 'Montana bar', NULL),
(NULL, 7, 'Arizona Bar', NULL),
(NULL, 8, 'Nevada Bar', NULL),
(NULL, 9, 'New York Bar', NULL),
(NULL, 10, 'New York Bar', NULL),
(NULL, 6, 'Mississippi Bar', NULL),
(NULL, 7, 'California Bar', NULL),
(NULL, 8, 'Illinois Bar', NULL),
(NULL, 9, 'Indiana Bar', NULL),
(NULL, 10, 'Illinois Bar', NULL),
 (NULL, 6, 'Tallahassee Bar', NULL),
 (NULL, 7, 'Ocala Bar', NULL),
 (NULL, 8, 'Bay County Bar', NULL),
 (NULL, 9, 'Cincinatti Bar', NULL);

COMMIT;


START TRANSACTION;

INSERT INTO `case`
(cse_id, per_id, cse_type, cse_description, cse_start_date, cse_end_date, cse_notes)
VALUES
(NULL, 13, 'civil', 'client says that his logo is being used without his consent to promote a rival business', '2010-09-09', NULL, 'copyright infringement'),
(NULL, 12, 'criminal', 'client is charged with assaulting her husband during an argument', '2009-11-18', '2010-12-23', 'assault'),
(NULL, 14, 'civil', 'client broke an ankle while shopping at a local grocery store. no wet floor sign was posted althoug the floor had just been mopped', '2008-05-06', '200 8-07-23', 'slip and fall'),
(NULL, 11, 'criminal', 'client was charged with stealing several televisions from his former place of employment, client has a solid alibi', '2011-05-20', NULL, 'grand theft')
(NULL, 13, 'criminal', 'client charged with posession of 10 grams of cocaine, allgegedly found in his glove box by state police', '2011-06-05', NULL, 'posession of narcotics'),
(NULL, 14, 'civil', 'client alleges newspaper printed false information about his personal activities while he ran a large laundry business in a small nearby town.', '2007-01 -19', '2007-05-20', 'defamation'),
(NULL, 12, 'criminal', 'client charged with the murder of his co-worker over a lovers fued client has no alibi', '2010-03-20', NULL, 'murder'),
(NULL, 15, 'civil', 'client made the horrible mistake of selecting a degree other than IT and had to declare bankruptcy.', '2012-01-26', '2013-02-28', 'bankruptcy');

COMMIT;


START TRANSACTION;

INSERT INTO court 
(crt_id, crt_name, crt_street, crt_city, crt_state, crt_zip, crt_phone, crt_email, crt_url, crt_notes)
VALUES
(NULL, 'leon county circuit court', '301 south monroe street', 'tallahassee', 'fl', 323035292, 8506065504, 'Iccc@us.fl.gov', 'http://www.leoncountycircuitcourt.gov/', NULL),
(NULL, 'leon country traffic court', '1921 thomasville road', 'tallahassee', 'fl', 323035292, 8505774100, 'lctc@us.fl.gov', 'http://www.leoncountytrafficcourt.gov/', NULL),
(NULL, 'florida supreme court', '500 south duval street', 'tallahassee', 'fl', 323035292, 8504880125, 'fsc@us.fl.gov', 'http://www.floridasupremecourt.org/', NULL),
(NULL, 'orange country courthouse', '424 north orange avenue', 'orlando', 'fl', 328012248, 4078362000, 'occ@us.fl.gov', 'http://www.ninthcircuit.org/', NULL),
(NULL, 'fifth district court of appeal', '300 south beach street', 'daytona beach', 'fl', 321158763, 3862258600, '5dca@us.fl.gov', 'http://www.5dca.org/', NULL);

COMMIT;

START TRANSACTION;

INSERT INTO judge
(per_id, crt_id, jud_salary, jud_years_in_practice, jud_notes)
VALUES
(11, 5, 150000, 10, NULL),
(12, 4, 185000, 3, NULL),
(13, 4, 135000, 2, NULL),
(14, 3, 170000, 6, NULL),
(15, 1, 120000, 1, NULL);

COMMIT;

START TRANSACTION;

INSERT INTO judge_hist
(jhs_id, per_id, jhs_crt_id, jhs_date, jhs_type, jhs_salary, jhs_notes)
VALUES
(NULL, 11, 3, '2009-01-16', 'i', 130000, NULL),
(NULL, 12, 2, '2010-05-27', 'i', 140000, NULL),
(NULL, 13, 5, '2000-01-02', 'i', 115000, NULL),
(NULL, 13, 4, '2005-07-05', 'i', 135000, NULL),
(NULL, 14, 4, '2008-12-09', 'i', 155000, NULL),
(NULL, 15, 1, '2011-03-17', 'i', 120000, 'freshman justice'),
(NULL, 11, 5, '2010-07-05', 'i', 150000, 'assigned to another court'),
(NULL, 12, 4, '2012-10-08', 'i', 165000, 'became chief justice'),
(NULL, 14, 3, '2009-04-19', 'i', 170000, 'reassigned to court based upon local area population growth');

COMMIT;


START TRANSACTION;

INSERT INTO person
(per_id,per_ssn, per_fname, per_Iname, per_street, per_city, per_state, per_zip, per_email, per_dob, per_type, per_notes)
VALUES
(NULL, NULL, 'Steve', 'Rogers', '437 Southern Drive', 'Rochester', 'NY', 324402222, 'srogers@comcast.net', '1923-10-03', 'c', NULL),
(NULL, NULL, 'Bruce', 'Wayne', '1007 Mountain Drive', 'Gotham', 'NY', 003208440, 'bwayne@knology.net', '1968-03-20','c',NULL),
(NULL, NULL, 'Peter', 'Parker', '20 Ingram Street', 'New York', 'NY', 102862341, 'pparker@msn.com', '1988-09-12', 'c', NULL),
(NULL, NULL, 'Jane', 'Thompson', '13563 Ocean View Drive', 'Seattle', 'WA', 032084409, 'jthompson@gmail.com', '1978-05-08', 'c', NULL),
(NULL, NULL, 'Debra', 'Steele', '543 Oak Ln', 'Milwaukee', 'WI', 286234178, 'dsteele@verizon.net', '1994-07-19', 'c', NULL),
(NULL, NULL, 'Tony', 'Stark', '332 Palm Avenue', 'Malibu', 'CA', 902638332, 'tstark@yahoo.com', '1972-05-04', 'a', NULL),
(NULL, NULL, 'Hank', 'Pymi', '2355 Brown Street', 'Cleveland, OH', 022348890, 'hpym@aol.com', '1980-08-28', 'a', NULL),
(NULL, NULL, 'Bob', 'Best', '4902 Avendale Avenue', 'Scottsdale', 'AZ', 872638332, 'bbest@yahoo.com', '1992-02-10', 'a', NULL),
(NULL, NULL, 'Sandra', 'Dole', '87912 Lawrence Ave', 'Atlanta', 'GA', 002348890, 'sdole@gmail.com', '1990-01-26', 'a', NULL),
(NULL, NULL, 'Ben', 'Avery', '6432 Thunderbird Ln', 'Sioux Falls', 'SD', 562638332, 'bavery@hotmail.com', '1983-12-24', 'a', NULL),
(NULL, NULL, 'Arthur', 'Curry', '3304 Euclid Avenue', 'Miami', 'FL', 000219932, 'acurry@gmail.com', '1975-12-15', 'j', NULL),
(NULL, NULL, 'Diana', 'Price', '944 Green Street', 'Las Vegas', 'NU', 332048823, 'dprice@symaptico.com', '1980-08-22', 'j', NULL),
(NULL, NULL, 'Adam', 'urris', '98435 Valencia Dr.', 'Gulf Shores', 'AL', 870219932, 'ajurris@gmx.com', '1995-01-31', 'j', NULL),
(NULL, NULL, 'Judy', 'Sleen', '56343 Rover Ct.', 'Billings', 'MT', 672048823, 'jsleen@symaptico.com', '1970-03-22', 'j', NULL),
(NULL, NULL, 'Bill', 'Neiderheim', '43567 Netherland Blvd', 'South Bend', 'IN', 320219932, 'bneiderheim@comcast.net', '1982-03-13', 'j',NULL);

COMMIT;


START TRANSACTION;

INSERT INTO phone
(phn_id, per_id, phn_num, phn_type, phn_notes)
VALUES
(NULL, 1, 8032288827, 'c', NULL),
(NULL, 2, 2052338293, 'h', NULL),
(NULL, 4, 1034325598, 'w', 'has two office numbers'),
(NULL, 5, 6402338494, 'w', NULL),
(NULL, 6, 5508329842, 'F', 'fax number not currently working'),
(NULL, 7, 8202052203, 'c', 'prefers home calls'),
(NULL, 8, 4008338294, 'h', NULL),
(NULL, 9, 7654328912, 'w', NULL),
(NULL, 10, 5463721984, 'f', 'work fax number'),
(NULL, 11, 4537821902, 'h', 'prefers cell phone calls'),
 (NULL, 12, 7867821902, 'w', 'best number to reach'),
 (NULL, 13, 4537821654, 'w', 'call during lunch'),
 (NULL, 14, 3721821902, 'c', 'prefers cell phone calls'),
 (NULL, 15, 9217821945, 'F', 'use for faxing legal docs');

COMMIT;


START TRANSACTION;

INSERT INTO specialty
(spc_id, per_id, spc_type, spc_notes)
VALUES
(NULL, 6, 'business', NULL),
(NULL, 7, 'traffic', NULL),
(NULL, 8, 'bankruptcy', NULL),
(NULL, 9, 'insurance', NULL),
(NULL, 10, 'judicial', NULL),
(NULL, 6, 'environmental', NULL),
(NULL, 7, 'criminal', NULL),
(NULL, 8, 'real estate', NULL),
(NULL, 9, 'malpractice', NULL);

COMMIT;
