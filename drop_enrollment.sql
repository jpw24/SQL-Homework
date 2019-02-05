CREATE PROCEDURE `drop_enrollment` (
-- This procedure accepts 2 parameters
	StudentID_in varchar(45),
  CourseName_in varchar(45)
)
BEGIN
SET ID_Course_tmp = (SELECT ID_Course FROM course WHERE CourseName = CourseName_in);
SET ID_Class_tmp=(SELECT ID_Class FROM class WHERE ID_Course=ID_Course_tmp);

SET ID_Student_tmp=(SELECT StudentID FROM student where StudentID=StudentID_in);

DELETE FROM classparticipant WHERE ID_Student=ID_Student_tmp and ID_Class=ID_Class_tmp;

END
