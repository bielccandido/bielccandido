import os

restaurantes = [{'nome':'Padoca', 'categoria':'Brasileira', 'ativo':False}, 
                {'nome':'Paris 6', 'categoria':'Francesa',  'ativo':True},
                {'nome':'Kanela', 'categoria':'Italiana', 'ativo':False}]

def exibir_nome_programa():
    print('𝓢𝓪𝓫𝓸𝓻 𝓮𝔁𝓹𝓻𝓮𝓼𝓼\n')

def exibir_opc():
    print('1. Cadastrar restaurante')
    print('2. Listar restaurantes')
    print('3. Alternar estado do restaurante')
    print('4. Sair\n')

# função para finalizar app
def finalizar_app():
      exibir_subtitulo('Finalizando o app')

# função para voltar ao menu principal
def voltar_ao_menu_princ():
     input('\nDigite uma tecla para retornar ao menu principal ')
     main()


# função para opção invalida
def opçao_invalida():
     print('Opção invalida!\n')
     voltar_ao_menu_princ()

# função para limpar terminal e exibir texto
def exibir_subtitulo(texto):
    os.system('cls')
    linha = '*' * (len(texto))
    print(linha)
    print(texto)
    print(linha)
    print()

# função para cadastrar restaurantes
def cadastro_de_restaurante():
    exibir_subtitulo('Cadastro de novos restaurantes')
    nome_restaurante = input('Digite o nome do restaurante que deseja cadastrar: ')
    categoria = input(f'Digite o nome da categoria do restaurante {nome_restaurante}: ')
    dados_restaurante = {'nome':nome_restaurante, 'categoria':categoria, 'ativo':False }
    restaurantes.append(dados_restaurante)
    print(f'O restaurante {nome_restaurante} foi cadastrado com sucesso\n')
    voltar_ao_menu_princ()
    
# função para listar restaurantes
def listar_restaurantes():
    exibir_subtitulo('Listando os restaurantes')

    print(f'{'Nome do restaurante'.ljust(22)} | {'Categoria'.ljust(20)} | Status')
    for restaurante in restaurantes:
        nome_restaurante = restaurante['nome']
        categoria = restaurante['categoria']
        ativo = 'ativado' if restaurante['ativo'] else 'desativado'

        print(f'- {nome_restaurante.ljust(20)} | {categoria.ljust(20)} | {ativo} ')
    voltar_ao_menu_princ()

# função para alternar estado do restaurante (false/true)
def alternar_estado_rest():
    exibir_subtitulo('Alternando estado do restaurante')
    nome_restaurante = input('Digite o nome do restaurante que deseja alternar o estado: ')
    restaurante_encontrado = False

    for restaurante in restaurantes:
        if nome_restaurante == restaurante['nome']:
            restaurante_encontrado = True
            restaurante['ativo'] = not restaurante['ativo']
            mensagem = f'O restaurante {nome_restaurante} foi ativado com sucesso' if restaurante['ativo'] else f'O restaurante {nome_restaurante} foi desativado com sucesso'
            print(mensagem)

    if not restaurante_encontrado:
        print('O restaurante não foi encontrado')

    voltar_ao_menu_princ()


# função para escolher a opção
def escolher_opc():  
    try:    
        opção_escolhida = int(input('Escolha uma opção: '))

        if opção_escolhida == 1:
            cadastro_de_restaurante()
        elif opção_escolhida == 2:
            listar_restaurantes()
        elif opção_escolhida == 3:
            alternar_estado_rest()
        elif opção_escolhida == 4:
            finalizar_app()
        else:
            opçao_invalida()
    except:
         opçao_invalida()

# ordem dos códigos que serão executado assim que o programa for iniciado ( main )
def main():
    os.system('cls')
    exibir_nome_programa()
    exibir_opc()
    escolher_opc()


if _name_ == '_main_':
    main()
