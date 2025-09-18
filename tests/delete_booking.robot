*** Settings ***
Resource    ../resources/keywords.resource
Suite Setup    Authenticate as Admin

*** Test Cases ***
Delete Booking
    ${id}=    Create Booking    Sabrina    Freitas    200    2025-09-16    2025-09-19

    Delete Booking    ${id}
