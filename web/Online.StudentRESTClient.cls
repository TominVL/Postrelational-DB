Class Online.StudentRESTClient
{

ClassMethod RESTGetAll() As %Status
{
    Write "=== REST GET /students (mode=list) ===",!,!
    Set req = ##class(%Net.HttpRequest).%New()
    Set req.Server   = "localhost"
    Set req.Port     = 52773
    Set req.Username = "mrlok"
    Set req.Password = "loker123"

    Do req.Get("/csp/user/Online.StudentREST.cls?mode=list")

    Set resp = req.HttpResponse
    Do resp.Data.Rewind()
    While 'resp.Data.AtEnd {
        Write resp.Data.ReadLine(),!
    }
    Write !,!
    Quit $$$OK
}

ClassMethod RESTCreateOne() As %Status
{
    Write "=== REST POST /student (mode=create) ===",!,!
    Set req = ##class(%Net.HttpRequest).%New()
    Set req.Server   = "localhost"
    Set req.Port     = 52773
    Set req.ContentType = "application/x-www-form-urlencoded"
    Set req.Username = "mrlok"
    Set req.Password = "loker123"

    Set rnd   = $Random(100000)
    Set name  = "REST Client "_rnd
    Set email = "rest"_rnd_"@example.com"

    Set body = "FullName="_$ZCONVERT(name,"O","URL")_ "&Email="_$ZCONVERT(email,"O","URL")
    Do req.EntityBody.Write(body)
    Do req.Post("/csp/user/Online.StudentREST.cls?mode=create")

    Set resp = req.HttpResponse
    Do resp.Data.Rewind()
    While 'resp.Data.AtEnd {
        Write resp.Data.ReadLine(),!
    }
    Write !,!
    Quit $$$OK
}

}
