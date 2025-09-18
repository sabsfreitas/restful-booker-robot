*** Settings ***
Resource    ../resources/keywords.resource
Suite Setup    Authenticate as Admin

*** Test Cases ***
Cenário: GET - Get Bookings from Restful Booker 200
    ${bookings}=    Get Bookings
    FOR    ${b}    IN    @{bookings}
        Log    ${b}[bookingid] - ${b}[firstname] ${b}[lastname]
    END