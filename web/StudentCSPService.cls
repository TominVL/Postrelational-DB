Class Online.StudentCSPService Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
    Set action = %request.Get("action")
    Set id     = %request.Get("ID")
    Set name   = %request.Get("FullName")
    Set email  = %request.Get("Email")

    If action="save" {
        Do ..DoSave(id, name, email)
    } ElseIf action="delete" {
        Do ..DoDelete(id)
    }

    Write "<html><head>",!
    Write "<meta http-equiv=""refresh"" content=""0;url=/csp/user/StudentsList.csp"">",!
    Write "</head><body>",!
    Write "<p>Redirecting to Students list...</p>",!
    Write "</body></html>",!

    Quit $$$OK
}



ClassMethod DoSave(pID As %String = "", pName As %String = "", pEmail As %String = "") As %Status
{
    If pID'="" {
        // редагування існуючого студента
        Set st = ##class(Online.Student).%OpenId(pID)
        If st="" {
            Quit $$$ERROR($$$GeneralError,"Student not found")
        }
    } Else {
        Set st = ##class(Online.Student).%New()
    }

    Set st.FullName = pName
    Set st.Email    = pEmail

    Quit st.%Save()
}

ClassMethod DoDelete(pID As %String = "") As %Status
{
    If pID="" {
        Quit $$$ERROR($$$GeneralError,"ID is empty")
    }

    Quit ##class(Online.Student).%DeleteId(pID)
}

}
