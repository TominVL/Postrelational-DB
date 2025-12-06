Class Online.Course Extends %Persistent
{

Property Code  As %String(MINLEN=3, MAXLEN=12) [ Required ];
/// Робимо Code ключем IDKEY (див. пункт 2)
Index IDKEY On Code [ IdKey ];

Property Title As %String(MINLEN=3,MAXLEN=80) [ Required ];
Property Tags  As list Of %String;

/// Завжди обчислювана довжина назви курсу
Property TitleLength As %Integer [ Calculated ];

/// Кількість студентів на курсі (завжди обчислювана)
Property StudentCount As %Integer [ Calculated ];

Relationship School   As Online.School  [ Cardinality = parent,   Inverse = Courses ];
Relationship Lessons  As Online.Lesson  [ Cardinality = children, Inverse = Course  ];
Relationship Teacher  As Online.Teacher [ Cardinality = one,      Inverse = Courses ];
Relationship Students As Online.Student [ Cardinality = many,     Inverse = Enrolled ];

/// геттер для TitleLength
Method TitleLengthGet() As %Integer
{
    Quit $Length(..Title)
}

/// геттер для StudentCount – використовує dynamic SQL
Method StudentCountGet() As %Integer
{
    Set cnt = 0
    Set id = ..%Id()

    If id="" Quit 0

    &sql(SELECT COUNT(*) INTO :cnt
         FROM Online.Student
         WHERE Enrolled = :id)

    Quit cnt
}

/// Embedded SQL (простий) – рахує кількість курсів
ClassMethod CountAll() As %Integer
{
    Set cnt = 0
    &sql(SELECT COUNT(*) INTO :cnt FROM Online.Course)
    Quit cnt
}

/// Dynamic SQL + implicit join (стрілка ->)
/// Виводить студентів та їх курси, опційно фільтрує за префіксом назви курсу
ClassMethod ListStudentsDynamic(pPrefix As %String = "") As %Status
{
    // SQL з alias'ами колонок
    Set sql = "SELECT s.FullName, s.Email, " _
             "s.Enrolled->Code AS CourseCode, " _
             "s.Enrolled->Title AS CourseTitle " _
             "FROM Online.Student AS s"

    If pPrefix'="" {
        Set sql = sql_" WHERE s.Enrolled->Title %STARTSWITH ?"
    }

    Set stmt = ##class(%SQL.Statement).%New()
    Set sc   = stmt.%Prepare(sql)
    If $$$ISERR(sc) Quit sc

    If pPrefix'="" {
        Set rs = stmt.%Execute(pPrefix)
    } Else {
        Set rs = stmt.%Execute()
    }

    While rs.%Next() {
        Write rs.%Get("FullName"),"  ",
              rs.%Get("Email"),"  ",
              rs.%Get("CourseCode"),"  ",
              rs.%Get("CourseTitle"),!
    }

    Quit $$$OK
}

/// SQL-запит з аргументом
Query ByTitle(pPrefix As %String) As %SQLQuery
{
    SELECT ID, Code, Title
    FROM Online.Course
    WHERE Title %STARTSWITH :pPrefix
}


}
