Feature: Automatizar el backend de Pet Store

  Background:
    * url apiPetStore
    * def jsonCrearMascota = read('classpath:examples/json/crearMascota.json')
    * def jsonEditarMascota = read('classpath:examples/json/actualizarMascota.json')

  @TEST-1 @happypath @CrearMascota
  Scenario: Verificar la creacion de una nueva mascota en Pet Store - OK

    Given path 'pet'
    And request jsonCrearMascota
    When method post
    Then status 200
    And match response.id == 1096
    And match response.name == 'Firulais'
    And match response.status == 'available'
    And print response

    #guardar el id retornado
    * def idPet = response.id
    And print idPet


  @TEST-2 @happypath
  Scenario: Mostrar mascotas agrupadas por estado - OK

    Given path 'pet/findByStatus'
    And param status = 'available'
    When method get
    Then status 200
    And print response



  @TEST-3
  Scenario Outline: Mostrar mascotas agrupadas por cada estado - OK

    Given path 'pet/findByStatus'
    And param status = '<estados>'
    When method get
    Then status 200
    And print response
    And match each response[*].status == '<estados>'


    Examples:
      | estados |
      | available   |
      | pending     |
      | sold

  @TEST-4
  Scenario: Verificar la actualizacion de una mascota en Pet Store - OK

    * def petUpdate =
      """
      {
        "id": 1091,
        "category": {
          "id": 1,
          "name": "Dogs"
        },
        "name": "Firulais22",
        "photoUrls": ["string"],
        "tags": [
          {
            "id": 1,
            "name": "friendly"
          }
        ],
        "status": "available"
      }
      """

    Given path 'pet'
    And request petUpdate
    When method put
    Then status 200
    And print response

  @TEST-8
  Scenario: Verificar la actualizacion con json aparte mascota en Pet Store - OK


    Given path 'pet'
    * set jsonEditarMascota.id = '1091'
    * set jsonEditarMascota.name = 'Boby'
    * set jsonEditarMascota.status = 'sold'
    And request jsonEditarMascota
    When method put
    Then status 200
    And print response

  @TEST-5
  Scenario Outline: Mostrar mascota por id

    Given path 'pet/', '<idpet>'
    When method get
    Then status 200
    And print response

    Examples:
      | idpet |
      | 1091  |



  @TEST-6
  Scenario Outline: Eliminar una mascota pasando su id- OK

    Given path 'pet/', '<idpet>'
    When method delete
    Then status 200
    And print response

    Examples:
      | idpet |
      | 1   |
      | 2     |

  @TEST-7
  Scenario: Subir imagen- OK

    * def petId = 1091

    Given path 'pet', petId, 'uploadImage'
    And multipart file file = { read: 'subirImagen.png', filename: 'subirImagen.png', contentType: 'image/png' }
    And multipart field additionalMetadata = 'Foto de prueba'
    When method post
    Then status 200
    And print response

  #Llamar otro caso de prueba para usar

  @TEST-9
  Scenario: Mostrar mascota por id -OK
    * def idMascota = call read('classpath:examples/users/users.feature@CrearMascota')

    Given path 'pet/', idMascota.idPet
    When method get
    Then status 200
    And print response









    # When method get
    # Then status 200
    # And match response contains user
  