*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../resources/keywords.robot
Suite Setup    Authenticate as Admin

*** Test Cases ***
Update Booking
    ${booking_dates}=    Create Dictionary    checkin=2022-12-31    checkout=2023-01-01
    ${body}=    Create Dictionary    firstname=Sabrina    lastname=Freitas    totalprice=200    depositpaid=false    bookingdates=${booking_dates}
    ${create_resp}=    POST    url=https://restful-booker.herokuapp.com/booking    json=${body}
    Status Should Be    200    ${create_resp}
    ${id}=    Set Variable    ${create_resp.json()}[bookingid]

    ${new_dates}=    Create Dictionary    checkin=2023-01-02    checkout=2023-01-05
    ${new_body}=    Create Dictionary    firstname=Sabrina    lastname=Atualizada    totalprice=300    depositpaid=true    bookingdates=${new_dates}    additionalneeds=Breakfast
    ${header}=    Create Dictionary    Cookie=token\=${token}    Content-Type=application/json    Accept=application/json

    ${update_resp}=    PUT    url=https://restful-booker.herokuapp.com/booking/${id}    json=${new_body}    headers=${header}
    Status Should Be    200    ${update_resp}

    Should Be Equal    ${update_resp.json()}[lastname]    Atualizada
    Should Be Equal    ${update_resp.json()}[firstname]    Sabrina
    Should Be Equal As Numbers    ${update_resp.json()}[totalprice]    300
    Should Be True    ${update_resp.json()}[depositpaid]
    Dictionary Should Contain Value    ${update_resp.json()}    Breakfast
