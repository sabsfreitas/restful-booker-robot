*** Settings ***
Resource    ../resources/keywords.resource
Suite Setup    Authenticate as Admin

*** Test Cases ***
Get Bookings from Restful Booker
    ${bookings}=    Get Bookings
    FOR    ${b}    IN    @{bookings}
        Log To Console    ${b}[bookingid] - ${b}[firstname] ${b}[lastname]
    END