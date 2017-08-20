/*-
 * ============LICENSE_START=======================================================
 * VID
 * ================================================================================
 * Copyright (C) 2017 AT&T Intellectual Property. All rights reserved.
 * ================================================================================
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============LICENSE_END=========================================================
 */
CREATE TABLE IF NOT EXISTS `vid_openecomp`.`schema_info` (
   `SCHEMA_ID` VARCHAR(25) NOT NULL,
   `SCHEMA_DESC` VARCHAR(75) NOT NULL,
   `DATASOURCE_TYPE` VARCHAR(100) NULL DEFAULT NULL,
   `CONNECTION_URL` VARCHAR(200) NOT NULL,
   `USER_NAME` VARCHAR(45) NOT NULL,
   `PASSWORD` VARCHAR(45) NULL DEFAULT NULL,
   `DRIVER_CLASS` VARCHAR(100) NOT NULL,
   `MIN_POOL_SIZE` INT(11) NOT NULL,
   `MAX_POOL_SIZE` INT(11) NOT NULL,
   `IDLE_CONNECTION_TEST_PERIOD` INT(11) NOT NULL)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;
