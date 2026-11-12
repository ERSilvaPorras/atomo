# atomo

CLI en shell para automatizar tareas locales de desarrollo:

- actualización del CLI
- configuración local de Git
- gestión de claves SSH para GitHub
- limpieza de __pycache__
- snapshot de estructura de repositorio
- backup/importación de configuración de VS Code

## Requisitos

Base:

- `sh` (POSIX)
- `git`
- `docker` (for docker subcommad)

Según comando:

- `ssh-agent` y `ssh-add`: `atomo sshup`, `atomo update`, `atomo vscode export`
- `code` (VS Code CLI): `atomo vscode export`, `atomo vscode import`
- `tree` y `xclip`: `atomo repo-tree`
- `xclip` o `pbcopy` + `xdg-open`: `atomo sshc`

## Actualizar version de desarrollo (`~/.atomo`)
```sh
sync -avui --exclude '.git' --prune-empty-dirs ./ ~/.atomo/
```
> [!CAUTION]
> Al momento de actualizar los nuevos cambios subidos a `atomo` se debe desintalar y reinstalar (evita problemas de merge).

## Instalación

Desde la raíz del proyecto:

```sh
./install.sh
```

Cuando el repositorio sea público:

```sh
curl -fsSL https://raw.githubusercontent.com/ersilvaporras/atomo/main/install.sh | zsh
```
Instalar los paquetes necesarios y docker:
```sh
atomo version
atomo server packages
atomo server docker
atomo sshc
```

El instalador:

- clona el proyecto en `~/.atomo`
- crea el symlink `~/.local/bin/atomo`

Si `~/.local/bin` no está en `PATH`:

```sh
export PATH="$HOME/.local/bin:$PATH"
```

## Uso

```sh
atomo <comando> [subcomando] [args]
```

## Referencia de comandos

### Core

| Comando | Argumentos | Qué hace |
| --- | --- | --- |
| `atomo update <key_suffix>` | `key_suffix` obligatorio | Carga `~/.ssh/id_ed25519_<key_suffix>` y actualiza el CLI (`git -C ~/.atomo pull`). |
| `atomo version` | - | Muestra el último tag en `~/.atomo`. Si no hay tags, devuelve `v0.0.0`. |
| `atomo src [repo_name]` | `repo_name` opcional | Configura `user.name` y `user.email` en el repo (por defecto repo actual). |
| `atomo rmpycache` | - | Elimina carpetas `__pycache__` de forma recursiva en el directorio actual. |
| `atomo repo-tree` | - | Imprime el árbol del repo actual (profundidad 5, excluye `.venv`) y lo copia al portapapeles. |
| `atomo repos [path] [ssh_name]` | `path` opcional, `ssh_name` opcional | Recorre repos bajo `path` (por defecto `~/Documents/git`) y muestra estado (necesita pull, commits pendientes, divergencia, cambios locales). |
| `atomo dev sync` | - | Actualiza la version instalada de atomo a fin de probar localmente nuevas funcionalidades|

### SSH

| Comando | Argumentos | Qué hace |
| --- | --- | --- |
| `atomo sshup <key_suffix>` | `key_suffix` obligatorio | Inicia `ssh-agent` (si hace falta) y agrega `~/.ssh/id_ed25519_<key_suffix>` al agente. |
| `atomo sshc` | interactivo | Crea una clave SSH (ed25519 o rsa), añade entrada en `~/.ssh/config`, copia la pública al portapapeles y abre la página de GitHub para añadir la clave. |
| `atomo pem handler` | interactivo | Busca y mueve un archivo `.pem` al directorio `~/.ssh`, ajusta permisos y agrega una entrada en `~/.ssh/config` para uso en servidores. |

### VS Code

Los comandos `vscode` trabajan sobre el repo de backup:

- URL: `git@github.com:ERSilvaPorras/learn-vscode.git`
- path local: `~/Documents/git/learn-vscode`

| Comando | Argumentos | Qué hace |
| --- | --- | --- |
| `atomo vscode export <key_suffix>` | `key_suffix` requerido para push | Exporta las extensiones instaladas a `config/extensions.txt`, hace commit y push al repo de backup si hay cambios. |
| `atomo vscode import` | - | Instala extensiones listadas en `config/extensions.txt`. |
| `atomo vscode settings` | - | Importa `config/settings.json` a `~/.config/Code/User/settings.json`. |

### Server

| Comando | Argumentos | Qué hace |
| --- | --- | --- |
| `atomo server export [ssh_name]` | `ssh_name` opcional | Exporta configuración del servidor (apt-mark, .zshrc, imágenes Docker) al repo `server-setup`. |
| `atomo server packages` | - | Instala paquetes básicos y configura UFW, unattended-upgrades y Zsh. |
| `atomo server docker` | - | Instala Docker y configura el servicio. |
| `atomo server pullim` | - | Pull de imágenes listadas en el backup (`images-docker.txt`) (requiere login a registry). |

## Docker
| Comando | Argumentos | Qué hace |
| `atomo docker nets` | - | Lista informacion sobre contenedores y sus redes. |
| `atomo docker tnets` | - | Imprime arbol de subredes y sus contenedores. |

## Ejemplos

```sh
# actualizar el CLI
atomo update work

# cargar clave para sesión actual
atomo sshup work

# establecer identidad git en repo actual
atomo src

# establecer identidad git en repo específico
atomo src learn-vscode

# exportar extensiones y sincronizar backup
atomo vscode export work

# restaurar extensiones y settings
atomo vscode import
atomo vscode settings

atomo docker nets
atomo docker tnets
```

## Solución de problemas

- Command not found: verifica que `~/.local/bin` esté en `PATH` y que exista el symlink `atomo`.
- SSH key not found: valida que exista `~/.ssh/id_ed25519_<key_suffix>`.
- VSCode CLI not found: instala VS Code y habilita el comando `code` en `PATH`.
- Backup repository is not a git repository: elimina `~/Documents/git/learn-vscode` y vuelve a ejecutar el comando `vscode` para clonar limpio.

## Notas operativas

- El proyecto asume instalación en `~/.atomo`.
- Subcomandos inválidos responden `Command not found`.
- `atomo src` usa identidad fija definida en el script (ERSilvaPorras / eduasilvaporras@frba.utn.edu.ar).

## Contribuciones

Pull requests y mejoras son bienvenidas. Abre un issue para discutir cambios grandes.

## Licencia

Revisa el fichero `LICENSE` en la raíz del repositorio para detalles sobre la licencia.
