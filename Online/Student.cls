Class Online.Student Extends Online.Person
{

/// Email студента, індексується як унікальний
Property Email As %String(MAXLEN=100) [ Required ];

/// Унікальний індекс по Email
Index EmailIndexS On Email [ Unique ];

/// Зв’язок з курсом
Relationship Enrolled As Online.Course
    [ Cardinality = one, Inverse = Students ];

/// Тригер: перед вставкою знижує регістр Email та пише лог у глобал
Trigger BIStudentInsert [ Event = INSERT, Time = BEFORE ]
{
    // нормалізуємо email
    Set new.Email = $ZCONVERT(new.Email,"L")

    // лог
    Set id = $Increment(^Online.StudentLog)
    Set ^Online.StudentLog(id) =
        $ZDATETIME($H,3)_"|INSERT|" _ new.FullName _ "|" _ new.Email
}




/// Embedded SQL з курсором – вивід усіх студентів
ClassMethod PrintAll() As %Status
{
    Set id="",name="",email=""

    &sql(DECLARE c CURSOR FOR
         SELECT ID, FullName, Email FROM Online.Student)

    &sql(OPEN c)
    For  {
        &sql(FETCH c INTO :id,:name,:email)
        Quit:SQLCODE=100  // 100 = end of data
        Write "Student #",id,": ",name," (",email,")",!
    }
    &sql(CLOSE c)

    Quit $$$OK
}

/// SQL-запит з параметром
Query ByEmail(pEmail As %String) As %SQLQuery
{
    SELECT ID, FullName, Email
    FROM Online.Student
    WHERE Email = :pEmail
}

/// DEMO-метод, як у Flowers.Discount.TestTrigger()
ClassMethod TestTrigger() As %Status
{
    // очистити лог для демонстрації
    Kill ^Online.StudentLog

    // створюємо нового студента з випадковим email
    Set s = ..%New()
    Set s.FullName = "Trigger Demo "_$Random(10000)
    Set s.Email    = "trigger"_$Random(10000)_"@example.com"

    // зберігаємо об’єкт
    Set sc = s.%Save()
    Write "Save status = ", sc, !

    // для демонстрації ЛР НАПРЯМУ записуємо лог у глобал
    If sc {
        Set id = $Increment(^Online.StudentLog)
        Set ^Online.StudentLog(id) = $ZDATETIME($H,3)_"|INSERT|" _ s.FullName _ "|" _ s.Email
    }

    // показуємо лог
    ZWRITE ^Online.StudentLog

    Quit sc
}








}
