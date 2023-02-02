*** Settings ***
Resource    ../resources/users.resource

*** Variables ***


*** Test Cases ***
Cenário 01: Cadastrar um novo usuário com sucesso na API ServeRest
    Criar um novo usuário
    Cadastrar o usuário criado na ServeRest
    Conferir se o usuário foi cadastrado corretamente