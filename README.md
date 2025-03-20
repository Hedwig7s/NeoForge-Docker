# SpongeMC-Docker

Docker image running [NeoForged](https://neoforged.net/)

## Usage

```bash
$ docker run -d \
    -v minecraft:/home/server \
    -p 25565:25565 \
    thisredh/purpurmc
```

## Environment Variables

All of the Environment Variables:

| Variable | Value | Description |
| - | - | - |
| NEOFORGE_VERSION | `21.4.119-beta` | Neoforge version to use |
| MC_EULA | `true` | Accepting the [EULA](https://account.mojang.com/documents/minecraft_eula) |
| MC_RAM_XMS | `1536M` | Preallocated RAM (for Purpur) |
| MC_RAM_XMX | `2048M` | Max RAM (for Purpur) |
| MC_PRE_JAR_ARGS | `<ARGS>` | Java Arg's (for experienced User's only) |
| MC_POST_JAR_ARGS | `<ARGS>` | Purpur Arg's (for experienced User's only) |
| MC_URL_ZIP_SERVER_FILES | `<URL to archive(zip, rar, tar, ...)>` | Import files from another Server or Import Config's/Plugin's (for experienced User's only) |
| MC_URL_ZIP_SERVER_FILES | `<URL to archive(zip, rar, tar, ...)>` | Import files from another Server or Import Config's/Plugin's (for experienced User's only) |
| MC_URL_ZIP_SERVER_FILES | `<URL to archive(zip, rar, tar, ...)>` | Import files from another Server or Import Config's/Plugin's (for experienced User's only) |
| SPONGE_TYPE | `spongevanilla` | Which sponge type to get (one of spongevanilla,spongeforge,spongeneo |
| SPONGE_VERSION | `1.21.3-13.0.0` | Which sponge version to get |
| FORCE_INSTALL | `<Should force install>` | Install whether the jar exists or not. Leave empty to update when jar is missing |
