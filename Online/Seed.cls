Class Online.Seed Extends %RegisteredObject
{

ClassMethod Run() As %Status
{
    // Простий хелпер для збереження з перевіркою
    Set sc = 1


    // ---- 0) Очистка даних (щоб не було дублів) ----
    Do ##class(Online.Lesson).%KillExtent()
    Do ##class(Online.Assignment).%KillExtent()
    Do ##class(Online.Quiz).%KillExtent()
    Do ##class(Online.Lecture).%KillExtent()
    Do ##class(Online.ContentItem).%KillExtent()
    Do ##class(Online.Course).%KillExtent()
    Do ##class(Online.Student).%KillExtent()
    Do ##class(Online.Teacher).%KillExtent()
    Do ##class(Online.Phone).%KillExtent()
    Do ##class(Online.School).%KillExtent()

    Try {
        // ---- 1) Phones ----
        Set phT1=##class(Online.Phone).%New()  Set phT1.Operator="Kyivstar", phT1.Number="+380501112233"  Set sc=phT1.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc
        Set phT2=##class(Online.Phone).%New()  Set phT2.Operator="Vodafone", phT2.Number="+380671112233"  Set sc=phT2.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc
        Set phS1=##class(Online.Phone).%New()  Set phS1.Operator="Lifecell", phS1.Number="+380931112233"  Set sc=phS1.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc
        Set phS2=##class(Online.Phone).%New()  Set phS2.Operator="Kyivstar", phS2.Number="+380991112233"  Set sc=phS2.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc

        // ---- 2) Teachers ----
        Set t1=##class(Online.Teacher).%New()  Set t1.FullName="Dr. Alice Kovalenko",   t1.Email="alice@school.example",  t1.Phone=phT1  Set sc=t1.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc
        Set t2=##class(Online.Teacher).%New()  Set t2.FullName="Prof. Bohdan Shevchenko", t2.Email="bohdan@school.example", t2.Phone=phT2  Set sc=t2.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc

        // ---- 3) Students ----
        Set s1=##class(Online.Student).%New()  Set s1.FullName="Ivan Petrenko",  s1.Email="ivan@student.example",  s1.Phone=phS1  Set sc=s1.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc
        Set s2=##class(Online.Student).%New()  Set s2.FullName="Olena Kravets", s2.Email="olena@student.example", s2.Phone=phS2  Set sc=s2.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc

        // ---- 4) School ----
        Set sch=##class(Online.School).%New()  Set sch.Name="Online Academy UA"  Set sc=sch.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc

        // ---- 5) Courses ----
        Set c1=##class(Online.Course).%New()  Set c1.Code="CS101", c1.Title="Intro to Programming", c1.School=sch, c1.Teacher=t1  Do c1.Tags.Insert("programming")  Do c1.Tags.Insert("basics")  Set sc=c1.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc
        Set c2=##class(Online.Course).%New()  Set c2.Code="DB201", c2.Title="Databases Fundamentals", c2.School=sch, c2.Teacher=t2  Do c2.Tags.Insert("databases")   Do c2.Tags.Insert("sql")     Set sc=c2.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc

        // ---- 6) Enroll (one↔many) ----
        Set s1.Enrolled=c1  Set sc=s1.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc
        Set s2.Enrolled=c2  Set sc=s2.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc

        // ---- 7) Content (Notes як %String, масиви через SetAt) ----
        Set lec1=##class(Online.Lecture).%New()   Set lec1.Title="Variables & Types", lec1.Notes="Основні типи даних, оголошення змінних."
        Do lec1.Slides.SetAt("https://slides.example/lec1/01.pdf","01")
        Do lec1.Slides.SetAt("https://slides.example/lec1/02.pdf","02")
        Set sc=lec1.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc

        Set lec2=##class(Online.Lecture).%New()   Set lec2.Title="SQL Basics", lec2.Notes="SELECT, WHERE, JOIN — вступ."
        Do lec2.Slides.SetAt("https://slides.example/lec2/01.pdf","01")
        Set sc=lec2.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc

        Set q1=##class(Online.Quiz).%New()        Set q1.Title="Quiz #1: Types", q1.Notes="10 запитань по базових типах."
        Do q1.Questions.SetAt("Int vs Float","Q1")
        Set sc=q1.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc

        Set q2=##class(Online.Quiz).%New()        Set q2.Title="Quiz #2: SQL",   q2.Notes="Перевірка SELECT та JOIN."
        Do q2.Questions.SetAt("SELECT syntax","Q1")
        Set sc=q2.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc

        Set a1=##class(Online.Assignment).%New()
        Set a1.Title="HW1: Calculator"
        Set a1.Notes="Написати консольний калькулятор."
        Set a1.Deadline = $ZDATEH("2025-10-30", 3)
        Do a1.%Save()

        Set a2=##class(Online.Assignment).%New()
        Set a2.Title="HW2: SQL Queries"
        Set a2.Notes="Підготувати 5 запитів з JOIN."
        Set a2.Deadline = $ZDATEH("2025-11-05", 3)
        Do a2.%Save()

        // ---- 8) Lessons ----
        Set l1=##class(Online.Lesson).%New()  Set l1.OrderNo=1, l1.Course=c1, l1.Content=lec1  Set sc=l1.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc
        Set l2=##class(Online.Lesson).%New()  Set l2.OrderNo=2, l2.Course=c1, l2.Content=q1    Set sc=l2.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc
        Set l3=##class(Online.Lesson).%New()  Set l3.OrderNo=1, l3.Course=c2, l3.Content=lec2  Set sc=l3.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc
        Set l4=##class(Online.Lesson).%New()  Set l4.OrderNo=2, l4.Course=c2, l4.Content=q2    Set sc=l4.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc
        Set l5=##class(Online.Lesson).%New()  Set l5.OrderNo=3, l5.Course=c1, l5.Content=a1    Set sc=l5.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc
        Set l6=##class(Online.Lesson).%New()  Set l6.OrderNo=3, l6.Course=c2, l6.Content=a2    Set sc=l6.%Save()  If 'sc Do $System.Status.DisplayError(sc) Quit sc

        Write !,"OK: Seed data created successfully.",!
    } Catch ex {
        Do $System.Status.DisplayError(ex.AsStatus())
    }
    Quit $$$OK
}
}