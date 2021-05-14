
import math
import path_planning as pp

#Children es igual que A*
def children(point,grid):
    """
        Calculates the children of a given node over a grid.
        Inputs:
            - point: node for which to calculate children.
            - grid: grid over which to calculate children.
        Outputs:
            - list of children for the given node.
    """
    x,y = point.grid_point
    if x > 0 and x < len(grid) - 1:
        if y > 0 and y < len(grid[0]) - 1:
            links = [grid[d[0]][d[1]] for d in\
                     [(x-1, y),(x,y - 1),(x,y + 1),(x+1,y),\
                      (x-1, y-1), (x-1, y+1), (x+1, y-1),\
                      (x+1, y+1)]]
        elif y > 0:
            links = [grid[d[0]][d[1]] for d in\
                     [(x-1, y),(x,y - 1),(x+1,y),\
                      (x-1, y-1), (x+1, y-1)]]
        else:
            links = [grid[d[0]][d[1]] for d in\
                     [(x-1, y),(x,y + 1),(x+1,y),\
                      (x-1, y+1), (x+1, y+1)]]
    elif x > 0:
        if y > 0 and y < len(grid[0]) - 1:
            links = [grid[d[0]][d[1]] for d in\
                     [(x-1, y),(x,y - 1),(x,y + 1),\
                      (x-1, y-1), (x-1, y+1)]]
        elif y > 0:
            links = [grid[d[0]][d[1]] for d in\
                     [(x-1, y),(x,y - 1),(x-1, y-1)]]
        else:
            links = [grid[d[0]][d[1]] for d in\
                     [(x-1, y), (x,y + 1), (x-1, y+1)]]
    else:
        if y > 0 and y < len(grid[0]) - 1:
            links = [grid[d[0]][d[1]] for d in\
                     [(x+1, y),(x,y - 1),(x,y + 1),\
                      (x+1, y-1), (x+1, y+1)]]
        elif y > 0:
            links = [grid[d[0]][d[1]] for d in\
                     [(x+1, y),(x,y - 1),(x+1, y-1)]]
        else:
            links = [grid[d[0]][d[1]] for d in\
                     [(x+1, y), (x,y + 1), (x+1, y+1)]]
    return [link for link in links if link.value != 9]



def theta_Star(inicio, meta, grid, heuristic):
    
    #Creamos los conjuntos iniciales
    abiertos = set()
    cerrados = set()

    #El actual es el inicio y añadimos a abiertos
    actual = inicio
    abiertos.add(actual)
    # Mientras abiertos no este vacio
    while abiertos:
        # Buscamos el abierto con menor heuristica (G+H)
        actual = min(abiertos, key=lambda o: o.G + o.H)
        pp.expanded_nodes += 1
        # Si el actual es la meta rehacemos el camino y lo devolvemos
        if actual == meta:
            path = []
            while actual.parent:
                path.append(actual)
                actual = actual.parent
            path.append(actual)
            return path[::-1]
        # Quitamos el actual de la lista de abiertos y lo metemos en cerrados
        abiertos.remove(actual)
        cerrados.add(actual)

        #Aqui falta lo del seudocodigo de UpdateBounds que solo ejecuta Thetha

        # Bucle a traves de los hijos
        for nodo in children(actual, grid):
            # Si esta en cerrados se pasa de el
            if nodo in cerrados:
                continue
            # Si esta abierto se comprueba si mejora la G score, si es asi se actualiza el nodo
            if nodo in abiertos:
                #Lo que hay que cambiar es a partir de aqui que seria la parte de UpdateVertex añadiendo lo de Lineofsight------------------------------------------------
                nueva_G = actual.G + actual.move_cost(nodo)
                if nodo.G > nueva_G:
                    nodo.G = nueva_G
                    nodo.parent = actual
            else:
                #Si no esta en abiertos se calcula su heuristica (g+h)
                nodo.G = actual.G + actual.move_cost(nodo)
                nodo.H = pp.heuristic[heuristic](nodo, meta)
                # el padre es el actual
                nodo.parent = actual
                # Se añade el nuevo nodo hijo a abiertos
                abiertos.add(nodo)
                #----------------------------------------------------------------------------------------------------------------------------------------------------------
        # Excepción si no hay camino
    raise ValueError('No Path Found')

pp.register_search_method('theta*', theta_Star)


def lineOfSight(current, node, grid):
    x0, y0 = current.grid_point
    x1, y1 = node.grid_point
    dy = y1 - y0
    dx = x1 - x0
    sx = 0
    sy = 0
    f = 0
    if dy < 0:
        dy = -dy
        sy = -1
    else:
        sy = 1
    if dx < 0:
        dx = -dx
        sx = -1
    else:
        sx = 1
    if dx >= dy:
        while x0 != x1:
            f += dy
            if f >= dx:
                a = grid[x0 + ((sx - 1) // 2)][y0 + ((sy - 1) // 2)].value
                if grid[x0 + ((sx - 1) // 2)][y0 + ((sy - 1) // 2)].value >= 5:
                    return False
                y0 += sy
                f -= dx
            if f != 0 and grid[x0 + ((sx - 1) // 2)][y0 + ((sy - 1) // 2)].value >=5:
                return False
            if dy == 0 and grid[x0 + ((sx - 1) // 2)][y0].value >=5 and grid[x0 + ((sx - 1) // 2)][y0 - 1].value >=5:
                return False
            x0 += sx
    else:
        while y0 != y1:
            f += dx
            if f >= dy:
                if grid[x0 + ((sx - 1) // 2)][y0 + ((sy - 1) // 2)].value >=5:
                    return False
                x0 += sx
                f -= dy
            if f != 0 and grid[x0 + ((sx - 1) // 2)][y0 + ((sy - 1) // 2)].value >=5:
                return False
            if dx == 0 and grid[x0 + ((sx - 1) // 2)][y0].value >=5 and grid[x0 + ((sx - 1) // 2)][y0 - 1].value >=5:
                return False
            y0 += sy
    return True

