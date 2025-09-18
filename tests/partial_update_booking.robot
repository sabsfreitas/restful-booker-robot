*** Settings ***
Resource    ../resources/keywords.resource
Suite Setup    Authenticate as Admin

*** Test Cases ***
Cenário: PATCH - Partial Update Booking 200
    ${id}=    Create Booking    Sabrina    Freitas    200    2022-12-31    2023-01-01    Café

    ${resp}=  Partial Update Booking    ${id}    Sabrina    Atualizada

    Should Be Equal    ${resp}[firstname]    Sabrina
    Should Be Equal    ${resp}[lastname]     Atualizada
    Dictionary Should Contain Key    ${resp}    totalprice
    Dictionary Should Contain Key    ${resp}    bookingdates