*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../resources/keywords.robot
Suite Setup    Authenticate as Admin

*** Test Cases ***
Get Bookings from Restful Booker
    ${response}=    GET    https://restful-booker.herokuapp.com/booking
    Status Should Be    200    ${response}
    ${bookings}=    Set Variable    ${response.json()}
    Log List    ${bookings}

    ${first5}=    Evaluate    $bookings[:5]
    FOR    ${booking}    IN    @{first5}
        ${id}=    Set Variable    ${booking}[bookingid]
        ${resp}=    GET    https://restful-booker.herokuapp.com/booking/${id}
        TRY
            Status Should Be    200    ${resp}
            Log    Booking ${id} encontrado
            Log    ${resp.json()}
        EXCEPT    HTTPError
            Log    Booking ${id} não existe mais (404)
        END
    END