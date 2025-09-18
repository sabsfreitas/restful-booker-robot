*** Settings ***
Resource    ../resources/keywords.resource
Suite Setup    Authenticate as Admin

*** Test Cases ***
Cenário: PUT - Update Booking 200
    ${id}=    Create Booking    Sabrina    Freitas    200    2022-12-31    2023-01-01

    ${resp}=  Update Booking    ${id}    Sabrina    Atualizada    300    2023-01-02    2023-01-05    Breakfast

    Should Be Equal                ${resp}[lastname]        Atualizada
    Should Be Equal                ${resp}[firstname]       Sabrina
    Should Be Equal As Numbers     ${resp}[totalprice]      300
    Should Be True                 ${resp}[depositpaid]
    Dictionary Should Contain Value    ${resp}              Breakfast