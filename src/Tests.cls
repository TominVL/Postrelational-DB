Class Online.Tests Extends %RegisteredObject
{

ClassMethod CleanUp()
{
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
    Write "Tables cleaned",!
}

ClassMethod TestCreateObjects()
{
    Do ..CleanUp()
    Write !,"--- Test_CreateObjects ---",!

    Set ph = ##class(Online.Phone).%New()
    Set ph.Operator = "Kyivstar"
    Set ph.Number   = "+380501234567"
    Set sc = ph.%Save()
    Write "Phone save status = ",sc,!

    Set t = ##class(Online.Teacher).%New()
    Set t.FullName = "Teacher 1"
    Set t.Email    = "t1@test.com"
    Set t.Phone    = ph
    Set sc = t.%Save()
    Write "Teacher save status = ",sc,!

    Set sch = ##class(Online.School).%New()
    Set sch.Name = "Test School"
    Set sc = sch.%Save()
    Write "School save status = ",sc,!

    Set c = ##class(Online.Course).%New()
    Set c.Code   = "CS111"
    Set c.Title  = "Test Course"
    Set c.School = sch
    Set c.Teacher = t
    Do c.Tags.Insert("tag1")
    Set sc = c.%Save()
    Write "Course save status = ",sc,!
}

ClassMethod TestUniqueRequired()
{
    Do ..CleanUp()
    Write !,"--- Test_Unique_Required ---",!

    Set ph = ##class(Online.Phone).%New()
    Set ph.Operator = "Vodafone"
    Set ph.Number   = "+380671234567"
    Do ph.%Save()

    Set s1 = ##class(Online.Student).%New()
    Set s1.FullName = "Student 1"
    Set s1.Email    = "s1@test.com"
    Set s1.Phone    = ph
    Set sc = s1.%Save()
    Write "Student1 save status = ",sc,!

    Set s2 = ##class(Online.Student).%New()
    Set s2.FullName = "Duplicate"
    Set s2.Email    = "s1@test.com"  ; той самий email
    Set s2.Phone    = ph
    Set sc = s2.%Save()
    Write "Student2 with same email (expected fail) = ",sc,!

    Set c = ##class(Online.Course).%New()
    Set c.Code = "BAD01"
    Set sc = c.%Save()
    Write "Save Course without Title (expected fail) = ",sc,!
}

ClassMethod TestRelationshipDelete() As %Status
{
    Do ..CleanUp()
    Write !,"--- Test_Relationship_Delete ---",!

    Set ph = ##class(Online.Phone).%New()
    Set ph.Operator = "Test"
    Set ph.Number   = "111"
    Do ph.%Save()

    Set t = ##class(Online.Teacher).%New()
    Set t.FullName = "RelTeacher"
    Set t.Email    = "rel@test.com"
    Set t.Phone    = ph
    Do t.%Save()

    Set sch = ##class(Online.School).%New()
    Set sch.Name = "RelSchool"
    Do sch.%Save()

    Set c = ##class(Online.Course).%New()
    Set c.Code   = "REL01"
    Set c.Title  = "Rel Test"
    Set c.School = sch
    Set c.Teacher = t
    Do c.%Save()

    Set lec = ##class(Online.Lecture).%New()
    Set lec.Title = "RelLecture"
    Do lec.%Save()

    Set l = ##class(Online.Lesson).%New()
    Set l.OrderNo = 1
    Set l.Course  = c
    Set l.Content = lec
    Do l.%Save()

    Set sc = c.%DeleteId(c.%Id())
    Write "Delete Course with child Lesson (expected fail) = ",$System.Status.IsError(sc),!
    Do:$System.Status.IsError(sc) $System.Status.DisplayError(sc)

    Set sc = l.%DeleteId(l.%Id())
    Write "Delete Lesson status = ",$System.Status.IsError(sc),!
    Do:$System.Status.IsError(sc) $System.Status.DisplayError(sc)

    Set sc = c.%DeleteId(c.%Id())
    Write "Delete Course after child removed (expected ok) = ",$System.Status.IsError(sc),!
    Do:$System.Status.IsError(sc) $System.Status.DisplayError(sc)

    Quit $$$OK   ; <- ОБОВʼЯЗКОВО
}

ClassMethod RunAll()
{
    Do ..TestCreateObjects()
    Do ..TestUniqueRequired()
    Do ..TestRelationshipDelete()
}

}
