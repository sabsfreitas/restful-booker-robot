*** Settings ***
Resource    ../resources/keywords.resource
Suite Setup    Authenticate as Admin

*** Test Cases ***
Cenário: DELETE - Delete Booking 200
    ${id}=    Create Booking    Sabrina    Freitas    200    2025-09-16    2025-09-19

    Delete Booking    ${id}
