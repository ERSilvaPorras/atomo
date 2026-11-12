# atom

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

- `ssh-agent` y `ssh-add`: `atom sshup`, `atom update`, `atom vscode export`
- `code` (VS Code CLI): `atom vscode export`, `atom vscode import`
- `tree` y `xclip`: `atom repo-tree`
- `xclip` o `pbcopy` + `xdg-open`: `atom sshc`

## Actualizar version de desarrollo (`~/.atom`)
```sh
sync -avui --exclude '.git' --prune-empty-dirs ./ ~/.atom/
```
> [!CAUTION]
> Al momento de actualizar los nuevos cambios subidos a `atom` se debe desintalar y reinstalar (evita problemas de merge).

## Instalación

Desde la raíz del proyecto:

```sh
./install.sh
```

Cuando el repositorio sea público:

```sh
curl -fsSL https://raw.githubusercontent.com/ersilvaporras/atom/main/install.sh | zsh
```
Instalar los paquetes necesarios y docker:
```sh
atom version
atom server packages
atom server docker
atom sshc
```

El instalador:

- clona el proyecto en `~/.atom`
- crea el symlink `~/.local/bin/atom`

Si `~/.local/bin` no está en `PATH`:

```sh
export PATH="$HOME/.local/bin:$PATH"
```

## Uso

```sh
atom <comando> [subcomando] [args]
```

## Referencia de comandos

### Core

| Comando | Argumentos | Qué hace |
| --- | --- | --- |
| `atom update <key_suffix>` | `key_suffix` obligatorio | Carga `~/.ssh/id_ed25519_<key_suffix>` y actualiza el CLI (`git -C ~/.atom pull`). |
| `atom version` | - | Muestra el último tag en `~/.atom`. Si no hay tags, devuelve `v0.0.0`. |
| `atom src [repo_name]` | `repo_name` opcional | Configura `user.name` y `user.email` en el repo (por defecto repo actual). |
| `atom rmpycache` | - | Elimina carpetas `__pycache__` de forma recursiva en el directorio actual. |
| `atom repo-tree` | - | Imprime el árbol del repo actual (profundidad 5, excluye `.venv`) y lo copia al portapapeles. |
| `atom repos [path] [ssh_name]` | `path` opcional, `ssh_name` opcional | Recorre repos bajo `path` (por defecto `~/Documents/git`) y muestra estado (necesita pull, commits pendientes, divergencia, cambios locales). |
| `atom dev sync` | - | Actualiza la version instalada de atom a fin de probar localmente nuevas funcionalidades|

### SSH

| Comando | Argumentos | Qué hace |
| --- | --- | --- |
| `atom sshup <key_suffix>` | `key_suffix` obligatorio | Inicia `ssh-agent` (si hace falta) y agrega `~/.ssh/id_ed25519_<key_suffix>` al agente. |
| `atom sshc` | interactivo | Crea una clave SSH (ed25519 o rsa), añade entrada en `~/.ssh/config`, copia la pública al portapapeles y abre la página de GitHub para añadir la clave. |
| `atom pem handler` | interactivo | Busca y mueve un archivo `.pem` al directorio `~/.ssh`, ajusta permisos y agrega una entrada en `~/.ssh/config` para uso en servidores. |

### VS Code

Los comandos `vscode` trabajan sobre el repo de backup:

- URL: `git@github.com:ERSilvaPorras/learn-vscode.git`
- path local: `~/Documents/git/learn-vscode`

| Comando | Argumentos | Qué hace |
| --- | --- | --- |
| `atom vscode export <key_suffix>` | `key_suffix` requerido para push | Exporta las extensiones instaladas a `config/extensions.txt`, hace commit y push al repo de backup si hay cambios. |
| `atom vscode import` | - | Instala extensiones listadas en `config/extensions.txt`. |
| `atom vscode settings` | - | Importa `config/settings.json` a `~/.config/Code/User/settings.json`. |

### Server

| Comando | Argumentos | Qué hace |
| --- | --- | --- |
| `atom server export [ssh_name]` | `ssh_name` opcional | Exporta configuración del servidor (apt-mark, .zshrc, imágenes Docker) al repo `server-setup`. |
| `atom server packages` | - | Instala paquetes básicos y configura UFW, unattended-upgrades y Zsh. |
| `atom server docker` | - | Instala Docker y configura el servicio. |
| `atom server pullim` | - | Pull de imágenes listadas en el backup (`images-docker.txt`) (requiere login a registry). |

## Docker
| Comando | Argumentos | Qué hace |
| `atom docker nets` | - | Lista informacion sobre contenedores y sus redes. |
| `atom docker tnets` | - | Imprime arbol de subredes y sus contenedores. |

## Ejemplos

```sh
# actualizar el CLI
atom update work

# cargar clave para sesión actual
atom sshup work

# establecer identidad git en repo actual
atom src

# establecer identidad git en repo específico
atom src learn-vscode

# exportar extensiones y sincronizar backup
atom vscode export work

# restaurar extensiones y settings
atom vscode import
atom vscode settings

atom docker nets
atom docker tnets
```

## Solución de problemas

- Command not found: verifica que `~/.local/bin` esté en `PATH` y que exista el symlink `atom`.
- SSH key not found: valida que exista `~/.ssh/id_ed25519_<key_suffix>`.
- VSCode CLI not found: instala VS Code y habilita el comando `code` en `PATH`.
- Backup repository is not a git repository: elimina `~/Documents/git/learn-vscode` y vuelve a ejecutar el comando `vscode` para clonar limpio.

## Notas operativas

- El proyecto asume instalación en `~/.atom`.
- Subcomandos inválidos responden `Command not found`.
- `atom src` usa identidad fija definida en el script (ERSilvaPorras / eduasilvaporras@frba.utn.edu.ar).

## Contribuciones

Pull requests y mejoras son bienvenidas. Abre un issue para discutir cambios grandes.

## Licencia

Revisa el fichero `LICENSE` en la raíz del repositorio para detalles sobre la licencia.
