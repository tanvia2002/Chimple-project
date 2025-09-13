-- flagging invalid records from assignments table

-- Adding a new table to flag the records
ALTER TABLE assignments ADD COLUMN assignment_status VARCHAR(10);


UPDATE assignments
SET assignment_status = CASE
    WHEN completed_date < assigned_date THEN 'Invalid'
    ELSE 'Valid'
END;

-- Records having completed_date before assigned_date is flagged as invalid

select * from assignments
where assignment_status="Invalid";

