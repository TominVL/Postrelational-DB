Class Online.Course Extends %Persistent
{
Property Code As %String(MINLEN=3, MAXLEN=12) [ Required ];
Index CodeIndex On Code [ Unique ];
Property Title As %String(MINLEN=3,MAXLEN=80) [ Required ];
Property Tags As list Of %String;

Relationship School As Online.School [ Cardinality = parent, Inverse = Courses ];
Relationship Lessons As Online.Lesson [ Cardinality = children, Inverse = Course ];
Relationship Teacher As Online.Teacher [ Cardinality = one, Inverse = Courses ];
Relationship Students As Online.Student [ Cardinality = many, Inverse = Enrolled ];

}
