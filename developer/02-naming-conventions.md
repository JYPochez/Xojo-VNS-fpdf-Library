# Naming Conventions

## Constants
- **Global Constants**: `gk` prefix (e.g., `gkA4Width`)
- **Class Constants**: `k` prefix (e.g., `kDefaultMargin`)

## Enumerations
- **Enum Names**: `e` prefix (e.g., `ePageFormat`, `ePageOrientation`)
- **Enum Values**: PascalCase (e.g., `Portrait`, `Landscape`)

## Properties
- **Private Properties**: `m` prefix (e.g., `mPages`, `mCurrentFont`)
- **Public Properties**: No prefix (e.g., `Error`, `PageCount`)

## Methods
- **Action Methods**: Verb-first (e.g., `AddPage`, `SetFont`, `DrawLine`)
- **Query Methods**: Get-prefix (e.g., `GetPageCount`, `GetStringWidth`)
