*** Settings ***
Resource    ../resources/keywords.resource
Suite Setup    Authenticate as Admin

*** Test Cases ***
Cenário: POST, GET, PATCH, PUT, DELETE - Full CRUD 200
    ${id}=    Create Booking    Sabrina    Freitas    200    2022-12-31    2023-01-01
    ${data}=  Get Booking By Id    ${id}
    Should Be Equal    ${data}[firstname]    Sabrina
    Should Be Equal    ${data}[lastname]     Freitas

    ${patch}=    Partial Update Booking    ${id}    Sabrina    Atualizada
    Should Be Equal    ${patch}[lastname]    Atualizada

    ${update}=    Update Booking    ${id}    Sabrina    Final    300    2023-01-02    2023-01-05
    Should Be Equal    ${update}[lastname]    Final

    Delete Booking    ${id}
