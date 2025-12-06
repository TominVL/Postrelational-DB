Class Online.Seed Extends %RegisteredObject
{

ClassMethod Run()
{
    // --- Очистка старих даних ---
    Do ##class(Online.Lesson).%KillExtent()
    Do ##class(Online.Assignment).%KillExtent()
    Do ##class(Online.Quiz).%KillExtent()
    Do ##class(Online.Lecture).%KillExtent()
    Do ##class(Online.ContentItem).%KillExtent()
    Do ##class(Online.Student).%KillExtent()
    Do ##class(Online.Course).%KillExtent()
    Do ##class(Online.Teacher).%KillExtent()
    Do ##class(Online.Phone).%KillExtent()
    Do ##class(Online.School).%KillExtent()
    Kill ^Online.StudentLog, ^Online.StudentSeq

    // --- Phones (тільки для викладачів) ---
    Set phT1 = ##class(Online.Phone).%New()
    Set phT1.Operator = "Kyivstar"
    Set phT1.Number   = "+380501112233"
    Do phT1.%Save()

    Set phT2 = ##class(Online.Phone).%New()
    Set phT2.Operator = "Vodafone"
    Set phT2.Number   = "+380671112233"
    Do phT2.%Save()

    // --- Teachers ---
    Set t1 = ##class(Online.Teacher).%New()
    Set t1.FullName = "Dr. Alice Kovalenko"
    Set t1.Email    = "alice@school.example"
    Set t1.Phone    = phT1
    Do t1.%Save()

    Set t2 = ##class(Online.Teacher).%New()
    Set t2.FullName = "Prof. Bohdan Shevchenko"
    Set t2.Email    = "bohdan@school.example"
    Set t2.Phone    = phT2
    Do t2.%Save()

    // --- Students (БЕЗ Phone, бо властивості вже немає) ---
    Set s1 = ##class(Online.Student).%New()
    Set s1.FullName = "Ivan Petrenko"
    Set s1.Email    = "ivan@student.example"
    Do s1.%Save()

    Set s2 = ##class(Online.Student).%New()
    Set s2.FullName = "Olena Kravets"
    Set s2.Email    = "olena@student.example"
    Do s2.%Save()

    // --- School ---
    Set sch = ##class(Online.School).%New()
    Set sch.Name = "Online Academy UA"
    Do sch.%Save()

    // --- Courses з кодами 101 / 201 / 301 ---
    Set c1 = ##class(Online.Course).%New()
    Set c1.Code    = "101"
    Set c1.Title   = "Basics of Programming"
    Set c1.School  = sch
    Set c1.Teacher = t1
    Do c1.Tags.Insert("programming")
    Do c1.Tags.Insert("basics")
    Do c1.%Save()

    Set c2 = ##class(Online.Course).%New()
    Set c2.Code    = "201"
    Set c2.Title   = "Database Fundamentals"
    Set c2.School  = sch
    Set c2.Teacher = t2
    Do c2.Tags.Insert("databases")
    Do c2.Tags.Insert("sql")
    Do c2.%Save()

    Set c3 = ##class(Online.Course).%New()
    Set c3.Code    = "301"
    Set c3.Title   = "Web Development Basics"
    Set c3.School  = sch
    Set c3.Teacher = t1
    Do c3.Tags.Insert("web")
    Do c3.Tags.Insert("frontend")
    Do c3.%Save()

    // --- Enroll students ---
    Set s1.Enrolled = c1  Do s1.%Save()   // Ivan -> 101 (Basics of Programming)
    Set s2.Enrolled = c2  Do s2.%Save()   // Olena -> 201 (Database Fundamentals)

    // --- (опційно) Якщо треба лекції/квізи/дз – можна додати нижче як у старому seed ---
    // Для твоїх пунктів ЛР вони не критичні.

    Write !,"OK: Seed data created successfully.",!
    Quit
}

}
