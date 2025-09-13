CREATE TABLE facts_table AS
SELECT
    f.student_id,
    f.date,
    COALESCE(a.active_flag, FALSE) AS active_flag,
    COALESCE(l.lessons_completed, 0) AS lessons_completed,
    COALESCE(m.minutes_spent, 0) AS minutes_spent
FROM
    (
        
        SELECT DISTINCT student_id, date
        FROM (
            SELECT student_id, DATE(start_time) AS date FROM sessions
            UNION ALL
            SELECT student_id, DATE(completed_date) AS date FROM assignments
        ) AS t
    ) f
LEFT JOIN
    (
        SELECT student_id, DATE(start_time) AS date, TRUE AS active_flag
        FROM sessions
        GROUP BY student_id, DATE(start_time)
    ) a
    ON f.student_id = a.student_id AND f.date = a.date
LEFT JOIN
    (
        SELECT student_id, DATE(completed_date) AS date, COUNT(DISTINCT lesson_id) AS lessons_completed
        FROM assignments
        WHERE assignment_status = 'valid'
        GROUP BY student_id, DATE(completed_date)
    ) l
    ON f.student_id = l.student_id AND f.date = l.date
LEFT JOIN
    (
        SELECT student_id, DATE(start_time) AS date, SUM(TIMESTAMPDIFF(MINUTE, start_time, end_time)) AS minutes_spent
        FROM sessions
        WHERE sessions_status = 'valid'
        GROUP BY student_id, DATE(start_time)
    ) m
    ON f.student_id = m.student_id AND f.date = m.date;


select * from facts_table
order by date,student_id;









