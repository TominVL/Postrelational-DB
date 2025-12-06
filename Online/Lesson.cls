Class Online.Lesson Extends %Persistent
{
Property OrderNo As %Integer(MINVAL=1);
Relationship Course As Online.Course [ Cardinality = parent, Inverse = Lessons ];
Property Content As Online.ContentItem;

}
