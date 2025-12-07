Class Online.Faker Extends %RegisteredObject
{

ClassMethod Generate(pCourses=2, pStudentsPerCourse=3) As %Status
{
    Set sc = $$$OK
    Try {
        // Чистий старт (щоб не було дублів)
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

        // Одна школа
        Set sch=##class(Online.School).%New()
        Set sch.Name="Online Academy UA"  Do sch.%Save()

        // Кілька курсів, викладачів і студентів
        For i=1:1:pCourses {

            // phone + teacher
            Set ph=##class(Online.Phone).%New()
            Set ph.Operator=$Select((i#2)=0:"Kyivstar",1:"Vodafone")
            Set ph.Number="+38050"_$Extract("0000000",1,7-$Length(i))_i
            Do ph.%Save()

            Set t=##class(Online.Teacher).%New()
            Set t.FullName="Teacher #"_i
            Set t.Email="teacher"_i_"@school.example"
            Set t.Phone=ph
            Do t.%Save()

            // course
            Set c=##class(Online.Course).%New()
            Set c.Code="CS"_100+i, c.Title="Course #"_i, c.School=sch, c.Teacher=t
            Do c.Tags.Insert("tag"_i)
            Do c.%Save()

            // content
            Set lec=##class(Online.Lecture).%New()   Set lec.Title="Lecture "_i, lec.Notes="Intro "_i
            Do lec.Slides.SetAt("https://slides.example/"_i_"/01.pdf","01")  Do lec.%Save()

            Set quiz=##class(Online.Quiz).%New()     Set quiz.Title="Quiz "_i, quiz.Notes="Check "_i
            Do quiz.Questions.SetAt("Q1","1")        Do quiz.%Save()

            Set asg=##class(Online.Assignment).%New() Set asg.Title="HW "_i, asg.Notes="Do task "_i
            Set asg.Deadline = $ZDATEH($ZDATE($H,3),3) + (5*i)  Do asg.%Save()

            // lessons
            Set l1=##class(Online.Lesson).%New() Set l1.Course=c, l1.OrderNo=1, l1.Content=lec  Do l1.%Save()
            Set l2=##class(Online.Lesson).%New() Set l2.Course=c, l2.OrderNo=2, l2.Content=quiz Do l2.%Save()
            Set l3=##class(Online.Lesson).%New() Set l3.Course=c, l3.OrderNo=3, l3.Content=asg  Do l3.%Save()

            // students
            For j=1:1:pStudentsPerCourse {
                Set sph=##class(Online.Phone).%New()
                Set sph.Operator="Lifecell", sph.Number="+38093"_$Extract("0000000",1,7-$Length(j))_j
                Do sph.%Save()

                Set s=##class(Online.Student).%New()
                Set s.FullName="Student "_i_"."_j
                Set s.Email="student"_i_"_"_j_"@example.com"
                Set s.Phone=sph, s.Enrolled=c
                Do s.%Save()
            }
        }

        Write !,"OK: Faker data generated.",!
    } Catch ex {
        Set sc=ex.AsStatus() Do $System.Status.DisplayError(sc)
    }
    Quit sc
}
}
