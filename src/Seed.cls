Class Online.Seed Extends %RegisteredObject
{

ClassMethod Run()
{
    // --- Очистка старих даних (опційно, але зручно для чистого запуску) ---
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

    // --- Phones ---
    Set phT1 = ##class(Online.Phone).%New()
    Set phT1.Operator = "Kyivstar"
    Set phT1.Number   = "+380501112233"
    Do phT1.%Save()

    Set phT2 = ##class(Online.Phone).%New()
    Set phT2.Operator = "Vodafone"
    Set phT2.Number   = "+380671112233"
    Do phT2.%Save()

    Set phS1 = ##class(Online.Phone).%New()
    Set phS1.Operator = "Lifecell"
    Set phS1.Number   = "+380931112233"
    Do phS1.%Save()

    Set phS2 = ##class(Online.Phone).%New()
    Set phS2.Operator = "Kyivstar"
    Set phS2.Number   = "+380991112233"
    Do phS2.%Save()

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

    // --- Students ---
    Set s1 = ##class(Online.Student).%New()
    Set s1.FullName = "Ivan Petrenko"
    Set s1.Email    = "ivan@student.example"
    Set s1.Phone    = phS1
    Do s1.%Save()

    Set s2 = ##class(Online.Student).%New()
    Set s2.FullName = "Olena Kravets"
    Set s2.Email    = "olena@student.example"
    Set s2.Phone    = phS2
    Do s2.%Save()

    // --- School ---
    Set sch = ##class(Online.School).%New()
    Set sch.Name = "Online Academy UA"
    Do sch.%Save()

    // --- Courses (з TitleLength) ---
    Set c1 = ##class(Online.Course).%New()
    Set c1.Code        = "CS101"
    Set c1.Title       = "Intro to Programming"
    Set c1.TitleLength = $Length(c1.Title)
    Set c1.School      = sch
    Set c1.Teacher     = t1
    Do c1.Tags.Insert("programming")
    Do c1.Tags.Insert("basics")
    Do c1.%Save()

    Set c2 = ##class(Online.Course).%New()
    Set c2.Code        = "DB201"
    Set c2.Title       = "Databases Fundamentals"
    Set c2.TitleLength = $Length(c2.Title)
    Set c2.School      = sch
    Set c2.Teacher     = t2
    Do c2.Tags.Insert("databases")
    Do c2.Tags.Insert("sql")
    Do c2.%Save()

    // --- Enroll students ---
    Set s1.Enrolled = c1  Do s1.%Save()
    Set s2.Enrolled = c2  Do s2.%Save()

    // --- Lectures ---
    Set lec1 = ##class(Online.Lecture).%New()
    Set lec1.Title = "Variables & Types"
    Set lec1.Notes = "Основні типи даних, оголошення змінних."
    Do lec1.Slides.SetAt("https://slides.example/lec1/01.pdf","01")
    Do lec1.Slides.SetAt("https://slides.example/lec1/02.pdf","02")
    Do lec1.%Save()

    Set lec2 = ##class(Online.Lecture).%New()
    Set lec2.Title = "SQL Basics"
    Set lec2.Notes = "SELECT, WHERE, JOIN — вступ."
    Do lec2.Slides.SetAt("https://slides.example/lec2/01.pdf","01")
    Do lec2.%Save()

    // --- Quizzes ---
    Set q1 = ##class(Online.Quiz).%New()
    Set q1.Title = "Quiz #1: Types"
    Set q1.Notes = "10 запитань по базових типах."
    Do q1.Questions.SetAt("Int vs Float","Q1")
    Do q1.%Save()

    Set q2 = ##class(Online.Quiz).%New()
    Set q2.Title = "Quiz #2: SQL"
    Set q2.Notes = "Перевірка SELECT та JOIN."
    Do q2.Questions.SetAt("SELECT syntax","Q1")
    Do q2.%Save()

    // --- Assignments ---
    Set a1 = ##class(Online.Assignment).%New()
    Set a1.Title    = "HW1: Calculator"
    Set a1.Notes    = "Написати консольний калькулятор."
    Set a1.Deadline = $ZDATEH("2025-10-30",3)
    Do a1.%Save()

    Set a2 = ##class(Online.Assignment).%New()
    Set a2.Title    = "HW2: SQL Queries"
    Set a2.Notes    = "Підготувати 5 запитів з JOIN."
    Set a2.Deadline = $ZDATEH("2025-11-05",3)
    Do a2.%Save()

    // --- Lessons ---
    Set l1 = ##class(Online.Lesson).%New()
    Set l1.OrderNo = 1
    Set l1.Course  = c1
    Set l1.Content = lec1
    Do l1.%Save()

    Set l2 = ##class(Online.Lesson).%New()
    Set l2.OrderNo = 2
    Set l2.Course  = c1
    Set l2.Content = q1
    Do l2.%Save()

    Set l3 = ##class(Online.Lesson).%New()
    Set l3.OrderNo = 1
    Set l3.Course  = c2
    Set l3.Content = lec2
    Do l3.%Save()

    Set l4 = ##class(Online.Lesson).%New()
    Set l4.OrderNo = 2
    Set l4.Course  = c2
    Set l4.Content = q2
    Do l4.%Save()

    Set l5 = ##class(Online.Lesson).%New()
    Set l5.OrderNo = 3
    Set l5.Course  = c1
    Set l5.Content = a1
    Do l5.%Save()

    Set l6 = ##class(Online.Lesson).%New()
    Set l6.OrderNo = 3
    Set l6.Course  = c2
    Set l6.Content = a2
    Do l6.%Save()

    Write !,"OK: Seed data created successfully.",!
    Quit
}

}
