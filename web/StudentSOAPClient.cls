Class Online.StudentSOAPClient
{

ClassMethod Demo()
{
    Set username = "mrlok"
    Set password = "loker123"

    // 1) CreateStudent
    Write "=== SOAP CreateStudent ===",!,!
    Set req = ##class(%Net.HttpRequest).%New()
    Set req.Server="localhost", req.Port=52773
    Set req.ContentType="text/xml"
    Set req.Username = username
    Set req.Password = password

    Do req.SetHeader("SOAPAction","http://tempuri.org/CreateStudent")

    Set env = "<?xml version=""1.0""?>" _
              "<soap:Envelope xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"">" _
              "<soap:Body>" _
                "<CreateStudent xmlns=""http://tempuri.org"">" _
                  "<FullName>SOAP Demo</FullName>" _
                  "<Email>soapdemo@example.com</Email>" _
                "</CreateStudent>" _
              "</soap:Body></soap:Envelope>"

    Do req.EntityBody.Write(env)
    Do req.Post("/csp/user/Online.StudentSOAP.cls")

    Do ..ShowResponse(req)

    // 2) GetStudent (ID=1 для прикладу)
    Write "=== SOAP GetStudent (ID=1) ===",!,!
    Set req = ##class(%Net.HttpRequest).%New()
    Set req.Server="localhost", req.Port=52773
    Set req.ContentType="text/xml"
    Set req.Username = username
    Set req.Password = password

    Do req.SetHeader("SOAPAction","http://tempuri.org/GetStudent")

    Set env = "<?xml version=""1.0""?>" _
              "<soap:Envelope xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"">" _
              "<soap:Body>" _
                "<GetStudent xmlns=""http://tempuri.org"">" _
                  "<ID>1</ID>" _
                "</GetStudent>" _
              "</soap:Body></soap:Envelope>"

    Do req.EntityBody.Write(env)
    Do req.Post("/csp/user/Online.StudentSOAP.cls")

    Do ..ShowResponse(req)
}

ClassMethod ShowResponse(req As %Net.HttpRequest)
{
    Set resp = req.HttpResponse
    If '$IsObject(resp) {
        Write "No HttpResponse object",!! Quit
    }

    Do resp.Data.Rewind()
    While 'resp.Data.AtEnd {
        Write resp.Data.ReadLine(),!
    }
    Write !!  ; просто пустий рядок між відповідями
}

}
