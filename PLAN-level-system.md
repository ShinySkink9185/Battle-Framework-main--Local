# Plan: Configurar nivel Test como escena jugable

<!-- PLAN-METADATA
spec: SPEC-level-system.md
created: 2026-02-20
levels: 3
tasks: 3
dag_validated: false
dag_adjustments: 0
-->

## Spec

Basado en: SPEC-level-system.md

## Objetivo

Hacer que la escena Test.tscn sea un nivel funcional que se pueda cargar y jugar desde MatchScene, siguiendo el patrón establecido por los niveles existentes.

## NO Hacer

- No modificar level.gd ni stage_info.gd
- No cambiar la estructura del MatchScene más allá de test_stage

## Decisiones de Diseño

| Decisión | Justificación |
|----------|---------------|
| Posiciones de spawn genéricas (±5, 1, ±5) | Usuario ajustará en el editor visual de Godot |
| Sin música | Campo vacío permitido; no bloquea funcionalidad |
| Case-sensitive "Test" | Coincide con nombre de carpeta y archivo .tscn |

## Tareas

### Nivel 0

- [x] REQ-002: Crear StageInfo resource (Test.tres) `MUST`
  - Criterios:
    - [ ] Archivo `levels/Test/Test.tres` existe
    - [ ] Usa script `stage_info.gd` (uid://bh7hc4po624b3)
    - [ ] `display_name = "Test"`
    - [ ] `music_file_path = ""` (sin música por ahora)
  - Contexto: Seguir patrón de greenhill.tres. Ver sección "Referencia: greenhill.tres" en SPEC-level-system.md

### Nivel 1

- [x] REQ-001: Configurar Test.tscn como nivel jugable `MUST` (depende de: REQ-002)
  - Criterios:
    - [ ] Root node instancia `Sprite Battle 3D Test Map idea.glb` (uid://rhn1wxvhdt7p)
    - [ ] Root node tiene script `level.gd` (uid://dpsy1u0t5ei1o)
    - [ ] Root node referencia `Test.tres` como stage_info
    - [ ] 4 nodos `PlayerSpawn1`-`PlayerSpawn4` (Node3D) como hijos directos
    - [ ] `player_spawn_1`-`player_spawn_4` apuntan a los spawns via NodePath
    - [ ] `camera_root_parent = NodePath(".")`
  - Contexto: Seguir patrón exacto de greenhill.tscn. Ver sección "Referencia: greenhill.tscn" en SPEC-level-system.md. El .tscn actual tiene uid="uid://d0dbcssc3k435" (preservar).

### Nivel 2

- [x] REQ-003: Configurar MatchScene para cargar Test `MUST` (depende de: REQ-001)
  - Criterios:
    - [ ] `test_stage` en `match_scene/match_scene.tscn` cambiado a `"Test"`
    - [ ] Al ejecutar MatchScene, carga `res://levels/Test/Test.tscn`
  - Contexto: En match_scene.tscn línea 8, cambiar `test_stage = "holysummit"` a `test_stage = "Test"`

### Post-Completion

- [x] Inform user about spawn point fine-tuning in Godot editor

## Recursos (para preflight)

**Carpetas:**
- levels/Test/ (read/write)
- match_scene/ (read/write)
