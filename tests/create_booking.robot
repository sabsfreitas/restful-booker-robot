*** Settings ***
Resource    ../resources/keywords.resource
Suite Setup    Authenticate as Admin

*** Test Cases ***
Create a Booking at Restful Booker
    ${id}=    Create Booking    Sabrina    Freitas    200    2025-09-16    2025-09-19
    ${resp}=  Get Booking By Id    ${id}

    Should Be Equal                ${resp}[lastname]        Freitas
    Should Be Equal                ${resp}[firstname]       Sabrina
    Should Be Equal As Numbers     ${resp}[totalprice]      200
    Dictionary Should Contain Value    ${resp}              Freitas