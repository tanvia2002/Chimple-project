create database chimple_project;
use chimple_project;
select * from sessions;

-- cleaning sessions table
-- 1.removing duplicates

ALTER TABLE sessions ADD COLUMN temp_id INT AUTO_INCREMENT PRIMARY KEY;
DELETE s1 FROM sessions s1
INNER JOIN sessions s2 
WHERE 
    s1.event_id = s2.event_id AND
    s1.student_id = s2.student_id AND
    s1.lesson_id = s2.lesson_id AND
    s1.start_time = s2.start_time AND
    s1.end_time = s2.end_time AND
    s1.device_id = s2.device_id AND
    s1.app_version = s2.app_version AND
    s1.temp_id > s2.temp_id;

ALTER TABLE sessions DROP COLUMN temp_id;

-- 2.replacing blank values in end_time to null

UPDATE sessions
SET end_time = NULL
WHERE end_time = '';

-- 3.Flagging the null records

ALTER TABLE sessions ADD COLUMN sessions_status VARCHAR(10);


UPDATE sessions
SET sessions_status = CASE
    WHEN end_time is null THEN 'Invalid'
    ELSE 'Valid'
END;


-- 4.Replacing null end_time values with average time difference

SELECT SEC_TO_TIME(AVG(TIMESTAMPDIFF(SECOND, start_time, end_time))) AS avg_time_difference
FROM sessions;

-- 5.The avg time difference is 00:32:59 and now we will replce the end_time with start_time + avg_time_difference 

UPDATE sessions
SET end_time = DATE_ADD(start_time, INTERVAL '00:32:59' HOUR_SECOND)
WHERE end_time IS NULL;
