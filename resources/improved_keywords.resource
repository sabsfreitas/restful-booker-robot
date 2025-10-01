*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    DateTime

*** Variables ***
${BASE_URL}                 https://restful-booker.herokuapp.com
${DEFAULT_FIRSTNAME}        Sabrina
${DEFAULT_LASTNAME}         Freitas
${DEFAULT_PRICE}            200
${DEFAULT_CHECKIN}          2025-01-01
${DEFAULT_CHECKOUT}         2025-01-05
${DEFAULT_ADDITIONAL_NEEDS}    Breakfast
${AUTH_TOKEN}               ${EMPTY}

&{DEFAULT_BOOKING_DATA}
...    firstname=${DEFAULT_FIRSTNAME}
...    lastname=${DEFAULT_LASTNAME}
...    totalprice=${DEFAULT_PRICE}
...    checkin=${DEFAULT_CHECKIN}
...    checkout=${DEFAULT_CHECKOUT}
...    additionalneeds=${DEFAULT_ADDITIONAL_NEEDS}

*** Keywords ***
Authenticate As Admin
    [Documentation]    Autentica como administrador e armazena o token
    ${auth_payload}=    Create Dictionary    username=admin    password=password123
    ${response}=        POST    url=${BASE_URL}/auth    json=${auth_payload}
    Status Should Be    200    ${response}
    ${auth_token}=      Set Variable    ${response.json()}[token]
    Set Suite Variable    ${AUTH_TOKEN}    ${auth_token}
    RETURN    ${auth_token}

Create Authentication Headers
    [Documentation]    Cria headers padrão para requisições autenticadas
    Variable Should Exist    ${AUTH_TOKEN}    msg=Token de autenticação não encontrado. Execute 'Authenticate As Admin' primeiro.
    ${headers}=    Create Dictionary
    ...    Cookie=token=${AUTH_TOKEN}
    ...    Content-Type=application/json
    ...    Accept=application/json
    RETURN    ${headers}

Create Booking With Default Data
    [Documentation]    Cria booking com dados padrão (para testes simples)
    ${booking_id}=    Create Booking With Custom Data    &{DEFAULT_BOOKING_DATA}
    RETURN    ${booking_id}

Create Booking With Custom Data
    [Documentation]    Cria booking com dados personalizados
    [Arguments]    &{booking_data}
    ${booking_dates}=    Create Dictionary
    ...    checkin=${booking_data.checkin}
    ...    checkout=${booking_data.checkout}
    
    ${booking_payload}=    Create Dictionary
    ...    firstname=${booking_data.firstname}
    ...    lastname=${booking_data.lastname}
    ...    totalprice=${booking_data.totalprice}
    ...    depositpaid=true
    ...    bookingdates=${booking_dates}
    ...    additionalneeds=${booking_data.additionalneeds}
    
    ${response}=    POST    url=${BASE_URL}/booking    json=${booking_payload}
    Status Should Be    200    ${response}
    ${booking_id}=    Set Variable    ${response.json()}[bookingid]
    Log    Booking criado com ID: ${booking_id}
    RETURN    ${booking_id}

Get Booking Details By Id
    [Documentation]    Busca detalhes de um booking pelo ID
    [Arguments]    ${booking_id}
    ${response}=    GET    ${BASE_URL}/booking/${booking_id}
    Status Should Be    200    ${response}
    ${booking_data}=    Set Variable    ${response.json()}
    Set To Dictionary    ${booking_data}    bookingid=${booking_id}
    RETURN    ${booking_data}

Get Multiple Bookings With Details
    [Documentation]    Obtém lista de bookings com detalhes (limitado por quantidade)
    [Arguments]    ${max_bookings}=5
    ${response}=    GET    ${BASE_URL}/booking
    Status Should Be    200    ${response}
    ${all_bookings}=    Set Variable    ${response.json()}
    ${total_count}=     Evaluate    len(${all_bookings})
    Log    Foram encontrados ${total_count} bookings no total
    
    ${limited_bookings}=    Evaluate    $all_bookings[:${max_bookings}]
    ${detailed_bookings}=   Create List
    
    FOR    ${booking_summary}    IN    @{limited_bookings}
        ${booking_id}=      Set Variable    ${booking_summary}[bookingid]
        ${booking_details}=    Get Booking Details By Id    ${booking_id}
        Append To List      ${detailed_bookings}    ${booking_details}
    END
    
    RETURN    ${detailed_bookings}

Update Booking Partially
    [Documentation]    Atualiza campos específicos de um booking (PATCH)
    [Arguments]    ${booking_id}    &{update_fields}
    ${auth_headers}=    Create Authentication Headers
    ${response}=        PATCH    url=${BASE_URL}/booking/${booking_id}    json=&{update_fields}    headers=${auth_headers}
    Status Should Be    200    ${response}
    Log    Booking ${booking_id} atualizado parcialmente
    RETURN    ${response.json()}

Update Booking Completely
    [Documentation]    Substitui todos os dados de um booking (PUT)
    [Arguments]    ${booking_id}    &{booking_data}
    ${booking_dates}=    Create Dictionary
    ...    checkin=${booking_data.checkin}
    ...    checkout=${booking_data.checkout}
    
    ${complete_payload}=    Create Dictionary
    ...    firstname=${booking_data.firstname}
    ...    lastname=${booking_data.lastname}
    ...    totalprice=${booking_data.totalprice}
    ...    depositpaid=true
    ...    bookingdates=${booking_dates}
    ...    additionalneeds=${booking_data.additionalneeds}
    
    ${auth_headers}=    Create Authentication Headers
    ${response}=        PUT    url=${BASE_URL}/booking/${booking_id}    json=${complete_payload}    headers=${auth_headers}
    Status Should Be    200    ${response}
    Log    Booking ${booking_id} atualizado completamente
    RETURN    ${response.json()}

Delete Booking By Id
    [Documentation]    Remove um booking pelo ID
    [Arguments]    ${booking_id}
    ${auth_headers}=    Create Authentication Headers
    ${response}=        DELETE    url=${BASE_URL}/booking/${booking_id}    headers=${auth_headers}
    Status Should Be    201    ${response}
    Log    Booking ${booking_id} removido com sucesso

Validate Booking Data
    [Documentation]    Valida se os dados do booking estão corretos
    [Arguments]    ${actual_data}    &{expected_data}
    FOR    ${field}    ${expected_value}    IN    &{expected_data}
        IF    '${field}' == 'totalprice'
            Should Be Equal As Numbers    ${actual_data}[${field}]    ${expected_value}
        ELSE
            Should Be Equal    ${actual_data}[${field}]    ${expected_value}
        END
    END