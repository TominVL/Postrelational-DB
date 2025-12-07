Class Online.StudentREST Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
    Try {
        Set mode = %request.Get("mode")

        If mode="list" {
            Do ..GetAll()
        }
        ElseIf mode="create" {
            Do ..Create()
        }
        Else {
            Set %response.ContentType = "application/json"
            Write "{""status"":""error"",""message"":""unknown mode""}"
        }
    }
    Catch ex {
        Set %response.ContentType = "application/json"
        Set msg = $Get(ex.DisplayString, $ZSTATUS)
        Set msg = $Replace(msg,"""","'")
        Write "{""status"":""error"",""message"":""",msg,"""}"
    }

    Quit $$$OK
}

/// GET /…?mode=list — повертає масив студентів у JSON
ClassMethod GetAll() As %Status
{
    Set %response.ContentType = "application/json"

    // створюємо JSON-масив
    Set arr = ##class(%DynamicArray).%New()

    Set stmt = ##class(%SQL.Statement).%New()
    Set sc   = stmt.%Prepare("SELECT ID, FullName, Email FROM Online.Student")
    If $$$ISERR(sc) {
        Set msg = $System.Status.GetErrorText(sc)
        Set msg = $Replace(msg,"""","'")
        Write "{""status"":""error"",""message"":""",msg,"""}"
        Quit $$$OK
    }

    Set rs = stmt.%Execute()
    While rs.%Next() {
        Set obj = ##class(%DynamicObject).%New()
        Do obj.%Set("ID",       rs.%Get("ID"))
        Do obj.%Set("FullName", rs.%Get("FullName"))
        Do obj.%Set("Email",    rs.%Get("Email"))
        Do arr.%Push(obj)
    }

    // виводимо JSON
    Write arr.%ToJSON()
    Quit $$$OK
}

/// POST /…?mode=create — створює студента, повертає JSON зі статусом та ID
ClassMethod Create() As %Status
{
    Set %response.ContentType = "application/json"

    Set name  = %request.Get("FullName")
    Set email = %request.Get("Email")

    If name="" {
        Write "{""status"":""error"",""message"":""FullName is empty""}"
        Quit $$$OK
    }

    If email="" {
        Write "{""status"":""error"",""message"":""Email is empty""}"
        Quit $$$OK
    }

    Set st = ##class(Online.Student).%New()
    Set st.FullName = name
    Set st.Email    = email

    Set sc = st.%Save()
    If $$$ISERR(sc) {
        Set msg = $System.Status.GetErrorText(sc)
        Set msg = $Replace(msg,"""","'")
        Write "{""status"":""error"",""message"":""",msg,"""}"
        Quit $$$OK
    }

    Write "{""status"":""ok"",""ID"":",st.%Id(),"}"
    Quit $$$OK
}

}
