Class Online.School Extends %Persistent
{
Property Name As %String(MINLEN=3,MAXLEN=80) [ Required ];
Index NameIndex On Name [ Unique ];
Relationship Courses As Online.Course [ Cardinality = children, Inverse = School ];

}
