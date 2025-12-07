Class Online.StudentSOAP Extends %SOAP.WebService
{

/// namespace і ім'я сервісу – прості, але стабільні
Parameter NAMESPACE   = "http://tempuri.org";
Parameter SERVICENAME = "StudentService";

Method CreateStudent(FullName As %String, Email As %String) As %Integer [ WebMethod ]
{
    Set obj = ##class(Online.Student).%New()
    Set obj.FullName = FullName
    Set obj.Email    = Email
    Do obj.%Save()
    Quit obj.%Id()
}

Method GetStudent(ID As %Integer,
                  ByRef FullName As %String = "",
                  ByRef Email    As %String = "") As %Boolean [ WebMethod ]
{
    Set obj = ##class(Online.Student).%OpenId(ID)
    If '$IsObject(obj) Quit 0

    Set FullName = obj.FullName
    Set Email    = obj.Email
    Quit 1
}

Method DeleteStudent(ID As %Integer) As %Boolean [ WebMethod ]
{
    Quit ##class(Online.Student).%DeleteId(ID)
}

}
