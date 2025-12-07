Class Online.Teacher Extends Online.Person
{
Property Email As %String(MAXLEN=100) [ Required ];
Index EmailIndexT On Email [ Unique ];   // ← інше ім’я

Property Phone As Online.Phone;
Relationship Courses As Online.Course [ Cardinality = many, Inverse = Teacher ];
}
