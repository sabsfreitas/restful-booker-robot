*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../resources/keywords.robot
Suite Setup    Authenticate as Admin

*** Test Cases ***
Partial Update Booking
    ${booking_dates}=    Create Dictionary    checkin=2022-12-31    checkout=2023-01-01
    ${body}=    Create Dictionary    firstname=Sabrina    lastname=Freitas    totalprice=200    depositpaid=false    bookingdates=${booking_dates}    additionalneeds=Café
    ${create_resp}=    POST    url=https://restful-booker.herokuapp.com/booking    json=${body}
    Status Should Be    200    ${create_resp}
    ${id}=    Set Variable    ${create_resp.json()}[bookingid]

    ${patch_body}=    Create Dictionary    firstname=Sabrina    lastname=Atualizada
    ${header}=    Create Dictionary    Cookie=token\=${token}    Content-Type=application/json    Accept=application/json

    ${patch_resp}=    PATCH    url=https://restful-booker.herokuapp.com/booking/${id}    json=${patch_body}    headers=${header}
    Status Should Be    200    ${patch_resp}

    Should Be Equal    ${patch_resp.json()}[firstname]    Sabrina
    Should Be Equal    ${patch_resp.json()}[lastname]    Atualizada
    Dictionary Should Contain Key    ${patch_resp.json()}    totalprice
    Dictionary Should Contain Key    ${patch_resp.json()}    bookingdates