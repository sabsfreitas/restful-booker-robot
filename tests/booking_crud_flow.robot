*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../resources/keywords.robot
Suite Setup    Authenticate as Admin

*** Test Cases ***
01 - Create Booking
    ${booking_dates}=    Create Dictionary    checkin=2022-12-31    checkout=2023-01-01
    ${body}=    Create Dictionary    firstname=Sabrina    lastname=Freitas    totalprice=200    depositpaid=false    bookingdates=${booking_dates}    additionalneeds=Café
    ${create_resp}=    POST    url=https://restful-booker.herokuapp.com/booking    json=${body}
    Status Should Be    200    ${create_resp}
    ${id}=    Set Variable    ${create_resp.json()}[bookingid]
    Set Suite Variable    ${id}
    Log To Console    Booking criado com ID: ${id}

02 - Get Booking by ID
    ${resp}=    GET    https://restful-booker.herokuapp.com/booking/${id}
    Status Should Be    200    ${resp}
    Should Be Equal    ${resp.json()}[firstname]    Sabrina
    Should Be Equal    ${resp.json()}[lastname]     Freitas
    Dictionary Should Contain Key    ${resp.json()}    bookingdates
    Log To Console    Booking ${id} retornado com sucesso.

03 - Partial Update Booking (PATCH)
    ${patch_body}=    Create Dictionary    firstname=Sabrina    lastname=Atualizada
    ${header}=    Create Dictionary    Cookie=token\=${token}    Content-Type=application/json    Accept=application/json
    ${patch_resp}=    PATCH    url=https://restful-booker.herokuapp.com/booking/${id}    json=${patch_body}    headers=${header}
    Status Should Be    200    ${patch_resp}
    Should Be Equal    ${patch_resp.json()}[lastname]    Atualizada
    Log To Console    Booking ${id} parcialmente atualizado.

04 - Full Update Booking (PUT)
    ${new_dates}=    Create Dictionary    checkin=2023-01-02    checkout=2023-01-05
    ${new_body}=    Create Dictionary    firstname=Sabrina    lastname=Final    totalprice=300    depositpaid=true    bookingdates=${new_dates}    additionalneeds=Breakfast
    ${header}=    Create Dictionary    Cookie=token\=${token}    Content-Type=application/json    Accept=application/json
    ${update_resp}=    PUT    url=https://restful-booker.herokuapp.com/booking/${id}    json=${new_body}    headers=${header}
    Status Should Be    200    ${update_resp}
    Should Be Equal    ${update_resp.json()}[lastname]    Final
    Should Be Equal As Numbers    ${update_resp.json()}[totalprice]    300
    Log To Console    Booking ${id} totalmente atualizado.

05 - Delete Booking
    ${header}=    Create Dictionary    Cookie=token\=${token}
    ${delete_resp}=    DELETE    url=https://restful-booker.herokuapp.com/booking/${id}    headers=${header}
    Status Should Be    201    ${delete_resp}
    Log To Console    Booking ${id} deletado com sucesso.