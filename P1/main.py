import numpy as np
from sys import exit


def errorHandler():
    return 'opcion invalida'


def salir():
    exit()


def funcionRecursiva(cad, n, s, af, estados):
    ns = af.tabla[af.q.index(s)][ord(cad[n])]  # siguiente(s) estado(s)
    if ns == -1:  # si no existe, termina
        print(f"{estados}({cad[n]})\t No es valida")

        if (n == 0):
            funcionRecursiva(cad.replace(cad[n], "", 1), n, s, af, "q" + af.s[0])

        elif (len(cad) < n + 1):
            funcionRecursiva(cad.replace(cad[n], "", 1), n, s, af, estados[0:estados.rfind("-> q") - 3])
        else:
            funcionRecursiva(cad.replace(cad[n], "", 1), n - 1, s, af, estados[0:estados.rfind("-> q") - 3])
        return
    for rama in ns:  # aqui ns pueden ser mas de 1 valor
        temp = estados
        estados = estados + f"({cad[n]})" + "-> q" + rama
        if (len(cad) == n + 1):  # se verifica si es el ultimo caracter de cadena

            if rama in af.f:  # si rama es un estado de aceptación:
                print(f"{estados} \t Es valida")
                # return
            else:
                print(f"{estados} \t No es valida")
                # return

        else:  # si aun faltan analizar se vuelve a llamar la funcion
            funcionRecursiva(cad, n + 1, rama, af, estados)
        estados = temp


def validaCadena(af):
    cad = input("Ingresa Cadena: ")
    print("Longitud de cad:" + str(len(cad)))
    funcionRecursiva(cad, 0, af.s[0], af, "q" + af.s[0])


def start():
    opp = 1
    archive = open('AF.txt', 'r')
    data = archive.read()
    archive.close()
    af = automa(data)
    tabla = af.crearTabla()  # Creamos tabla de transcision de estados
    af.imprimeTabla()

    while opp:
        print('''
            Menu de automatas
            1.- Ingresar cadena
            0.- Salir
            ''')
        opp = int(input('Opcion: '))

        if opp == 1:
            validaCadena(af)
        # init.get(opp, errorHandler)()

    # print(len(af.q))


class automa:
    q = []
    f = []
    s = []
    e = []
    d = []
    aux = []
    tabla = []

    def __init__(self, data):
        un = data.split('\n')

        for i in range(len(un)):
            if i == 0:
                self.q = [x.strip() for x in un[i].split(',')]
            elif i == 1:
                self.f = [x.strip() for x in un[i].split(',')]
            elif i == 2:
                self.s = [x.strip() for x in un[i].split(',')]
            elif i == 3:
                self.e = [x.strip() for x in un[i].split(',')]
            else:
                self.d.append([x.strip() for x in un[i].split(',')])

        # se recorreo el con el rango de lend

        self.af_complet()

    def af_complet(self):
        err = self.q[-1]
        err = int(err) + 1
        self.q.append(str(err))

        aux2 = []
        for s in self.q:
            for e in self.e:
                for w in self.d:
                    aux2.append(w[0:2])
        for s in self.q:
            for e in self.e:
                if not [s, e] in aux2:
                    self.aux.append(f'{s},{e},{err}\n')

        un = "".join(self.aux)
        un = un.split('\n')

        for i in range(len(un)):
            self.d.append(un[i].split(','))
        self.d.pop(-1)


    def crearTabla(self):
        self.tabla = -np.ones((len(self.q), 256))  # 256 columnas debido a ascii
        self.tabla = self.tabla.tolist()
        for t in self.d:  # por cada estado, se crea una celda
            if self.tabla[self.q.index(t[0])][ord(t[1][-1])] == -1:  # -1 por default si no existe
                self.tabla[self.q.index(t[0])][ord(t[1][-1])] = [t[2]]  # se rellena celda
            else:
                self.tabla[self.q.index(t[0])][ord(t[1][-1])].append(t[2])  # se anexa a la celda
        return self.tabla

    def imprimeTabla(self):
        indices = []

        for i in self.e:
            indices.append(ord(i))
        # print(indices)
        print("TABLA de TRANCISCIONES")
        print(np.array(self.tabla, dtype=object)[:, indices])# Solo se imprimen las columnas que pertenezcan al alfabeto y se pasa a objeto ya que af es un objeto


if __name__ == '__main__':
    menu = True
    while True:
        print('''
            Menu de automatas
            1.- Ingresar automata
            2.- Salir
            ''')
        opp = int(input('Opcion: '))

        init = {
            1: start,
            2: salir
        }
        init.get(opp, errorHandler)()