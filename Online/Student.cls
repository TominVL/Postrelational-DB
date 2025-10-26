Class Online.Student Extends Online.Person
{
Property Email As %String(MAXLEN=100) [ Required ];
Index EmailIndexS On Email [ Unique ];   // ← інше ім’я

Property Phone As Online.Phone;
Relationship Enrolled As Online.Course [ Cardinality = one, Inverse = Students ];
}
