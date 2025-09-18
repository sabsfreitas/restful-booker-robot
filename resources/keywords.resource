*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    https://restful-booker.herokuapp.com

*** Keywords ***
Authenticate as Admin
    ${body}=    Create Dictionary    username=admin    password=password123
    ${resp}=    POST    url=${BASE_URL}/auth    json=${body}
    Status Should Be    200    ${resp}
    ${token}=    Set Variable    ${resp.json()}[token]
    Set Suite Variable    ${token}

Create Booking
    [Arguments]    ${firstname}    ${lastname}    ${price}    ${checkin}    ${checkout}    ${needs}=Café
    ${dates}=    Create Dictionary    checkin=${checkin}    checkout=${checkout}
    ${body}=     Create Dictionary    firstname=${firstname}    lastname=${lastname}    totalprice=${price}    depositpaid=true    bookingdates=${dates}    additionalneeds=${needs}
    ${resp}=     POST    url=${BASE_URL}/booking    json=${body}
    Status Should Be    200    ${resp}
    ${id}=       Set Variable    ${resp.json()}[bookingid]
    Set Suite Variable    ${id}
    Log To Console    Booking criado com ID: ${id}
    RETURN  ${id}

Get Booking By Id
    [Arguments]    ${id}
    ${resp}=    GET    ${BASE_URL}/booking/${id}
    Status Should Be    200    ${resp}
    ${data}=    Set Variable    ${resp.json()}
    Set To Dictionary    ${data}    bookingid=${id}
    RETURN    ${data}

Get Bookings
    ${resp}=    GET    ${BASE_URL}/booking
    Status Should Be    200    ${resp}
    ${all}=    Set Variable    ${resp.json()}

    ${count}=    Evaluate    len(${all})
    Log To Console    Foram encontrados ${count} bookings.

    ${first5}=    Evaluate    $all[:5]
    ${result}=    Create List

    FOR    ${b}    IN    @{first5}
        ${id}=    Set Variable    ${b}[bookingid]
        ${detail}=    Get Booking By Id    ${id}
        Append To List    ${result}    ${detail}
    END

    RETURN    ${result}

Partial Update Booking
    [Arguments]    ${id}    ${firstname}    ${lastname}
    ${body}=    Create Dictionary    firstname=${firstname}    lastname=${lastname}
    ${header}=  Create Dictionary    Cookie=token\=${token}    Content-Type=application/json    Accept=application/json
    ${resp}=    PATCH    url=${BASE_URL}/booking/${id}    json=${body}    headers=${header}
    Status Should Be    200    ${resp}
    Log To Console    Booking ${id} parcialmente atualizado.
    RETURN  ${resp.json()}

Update Booking
    [Arguments]    ${id}    ${firstname}    ${lastname}    ${price}    ${checkin}    ${checkout}    ${needs}=Breakfast
    ${dates}=    Create Dictionary    checkin=${checkin}    checkout=${checkout}
    ${body}=     Create Dictionary    firstname=${firstname}    lastname=${lastname}    totalprice=${price}    depositpaid=true    bookingdates=${dates}    additionalneeds=${needs}
    ${header}=   Create Dictionary    Cookie=token\=${token}    Content-Type=application/json    Accept=application/json
    ${resp}=     PUT    url=${BASE_URL}/booking/${id}    json=${body}    headers=${header}
    Status Should Be    200    ${resp}
    Log To Console    Booking ${id} totalmente atualizado.
    RETURN  ${resp.json()}

Delete Booking
    [Arguments]    ${id}
    ${header}=    Create Dictionary    Cookie=token\=${token}
    ${resp}=      DELETE    url=${BASE_URL}/booking/${id}    headers=${header}
    Status Should Be    201    ${resp}
    Log To Console    Booking ${id} deletado com sucesso.