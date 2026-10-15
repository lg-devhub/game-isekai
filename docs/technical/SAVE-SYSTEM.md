# SAVE-SYSTEM — Arquitetura de Persistência Local e Recuperação de Falhas

Este documento especifica o sistema de persistência de dados de **Echoes of the Veil**, definindo a estratégia de salvamento atômico local, proteção contra corrupção por queda de energia ou fechamento abrupto, verificação de integridade por hash e versionamento com migração de dados.

---

## 1. Visão Geral do Fluxo de Salvamento Atômico

Para evitar corrupção de save caso o smartphone descarregue a bateria ou o jogador feche o aplicativo durante a gravação em disco, o `SaveSystem` opera de forma estritamente local utilizando o padrão **Atomic Write with Fallback Backup**:

```
[Dados em Memória (RAM)]
           │
           ▼
[Grava em Arquivo Temporário: slot_X.json.tmp]
           │
           ▼ Verifica integridade do JSON e calcula SHA-256/HMAC
           │
           ├── Se OK:
           │     1. Copia o save anterior atual para: slot_X.json.bak
           │     2. Renomeia slot_X.json.tmp para: slot_X.json (Operação Atômica do SO)
           │     3. Remove arquivos temporários antigos
           │
           └── Se Erro na gravação:
                 Emite sinal de alerta e mantém o save original intacto
```

---

## 2. Estrutura de Diretórios de Persistência Local

Os arquivos são gravados estritamente no diretório de isolamento seguro da Godot (`user://`), que mapeia para o sandbox de armazenamento interno do aplicativo no Android (`/data/data/com.empresa.echoesoftheveil/files/`) e iOS (`/Documents/`), sem exigir permissões de rede:

```text
user://
├── settings.cfg               # Configurações do jogador (ConfigFile)
└── saves/
    ├── slot_1.json            # Save ativo no Slot 1
    ├── slot_1.json.bak        # Backup de segurança da versão anterior
    ├── slot_2.json            # Slot 2 (Save Manual)
    ├── slot_2.json.bak
    ├── slot_3.json            # Slot 3 (Save Manual)
    ├── slot_3.json.bak
    └── autosave.json          # Slot dedicado para salvamento automático
```

---

## 3. Verificação de Integridade e Segurança Contra Adulteração

Para proteger o progresso do jogador e garantir que arquivos corrompidos não causem travamentos no jogo:

1. **Hash de Verificação (HMAC-SHA256):**
   - Ao final do arquivo JSON, é anexado um bloco de metadados:
     ```json
     {
       "_metadata": {
         "checksum": "a3f8b912c...",
         "engine_version": "Godot 4.x",
         "schema_version": 2
       }
     }
     ```
   - Antes de carregar o arquivo, o `SaveSystem` recalcula o hash SHA-256 do payload de dados e compara com o valor gravado.
2. **Recuperação Automática de Backup:**
   - Se o arquivo primário `slot_1.json` falhar na validação do parser JSON ou apresentar hash divergente (indicando corte abrupto de energia durante a gravação), o sistema emite um log de aviso e carrega automaticamente o arquivo `slot_1.json.bak`, notificando o jogador com a mensagem:  
     *"O arquivo de progresso mais recente foi recuperado a partir da cópia de segurança com sucesso."*

---

## 4. Versionamento de Esquema e Migração de Dados

Conforme novas atualizações pedagógicas e capítulos forem lançados nas Fases do Roadmap, o formato dos dados evolui com segurança:

```gdscript
# Trecho de lógica do SaveSystem.gd
func migrate_save_data(data: Dictionary) -> Dictionary:
    var version: int = data.get("save_version", 0)
    
    # Migração da Versão 1 para Versão 2 (Inclusão do Códice do Conhecimento)
    if version == 1:
        data["codice"] = {
            "unlocked_entries": [],
            "mastered_concepts": [],
            "spaced_reviews_completed": 0,
            "voluntary_revision_scores": {}
        }
        data["save_version"] = 2
        print("SaveSystem: Migração V1 -> V2 concluída com sucesso.")
        
    return data
```

---

## 5. Garantia Estrita de Operação 100% Off-line

Em total conformidade com os princípios centrais do projeto:
- **Zero Dependências Remotas:** O jogo não realiza requisições a servidores externos, não possui rotinas de login em nuvem e não condiciona a retenção de progresso a conectividade com a internet.
- **Portabilidade de Backup Local (Fase 6):** Caso o usuário deseje migrar seu progresso para outro dispositivo, o sistema fornecerá apenas uma função utilitária de exportação e importação manual de um arquivo criptografado (`echoes_backup.veil`) diretamente para a pasta de arquivos locais do aparelho, preservando a privacidade total do menor.
