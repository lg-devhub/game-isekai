# SETTINGS — Especificação do Sistema de Configurações do Jogador

Este documento define os parâmetros configuráveis, a persistência 100% local e as opções de acessibilidade do menu de opções de **Echoes of the Veil**.

---

## 1. Operação 100% Offline e Persistência Local

Todas as configurações são lidas e gravadas exclusivamente no arquivo de configuração local do dispositivo (`user://settings.cfg`), sem necessidade de conexão com internet, sincronização remota obrigatória ou telemetria invasiva.

---

## 2. Categorias de Configuração

### A. Áudio
- **Volume Geral (Master):** Slider linear de 0% a 100% (padrão: 80%).
- **Música (Music):** Slider linear de 0% a 100% (padrão: 75%).
- **Efeitos Sonoros (SFX):** Slider linear de 0% a 100% (padrão: 85%).
- **Ambiente (Ambience):** Slider linear de 0% a 100% (padrão: 70%).
- **Opção de Silenciar (Mute):** Alternador geral instantâneo.

### B. Display e Acessibilidade Visual
- **Controle de Brilho Visual (Shader de Modulação):** Ajuste de -30% a +30% na iluminação da cena do jogo via `CanvasModulate`.
  > *Nota de Limitação do Sistema Operacional:* Conforme restrições de permissão do Android/iOS, aplicativos de jogos não devem forçar a alteração do brilho dos LEDs físicos da tela. Uma mensagem instrutiva informa: *"Para alterar o brilho físico da tela do aparelho, utilize os controles rápidos do seu sistema operacional."*
- **Escala de Tipografia:** Seletor de tamanho de fonte (*Padrão 16pt*, *Grande 20pt*, *Extra Grande 24pt*) para garantir leitura confortável a jovens com dificuldades visuais.
- **Modo para Daltonismo:** Filtros matriciais para *Protanopia*, *Deuteranopia* e *Tritanopia*.
- **Alto Contraste:** Adiciona contornos reforçados em textos sobrepostos a ilustrações.
- **Redução de Movimento:** Desativa balanços rápidos de câmera e efeitos visuais intensos para prevenir cinetose.

### C. Jogabilidade e Suporte Pedagógico
- **Dificuldade dos Puzzles:**
  - *Relaxado:* Dicas mais detalhadas no Nível 1 e tolerância ampliada em cálculos de aproximação.
  - *Padrão (Investigador):* Equilíbrio canônico recomendado para a faixa de 12 a 17 anos.
  - *Mestre:* Menos apoios automáticos, incentivando dedução matemática e lógica autônoma.
  *(A alteração da dificuldade pode ser feita a qualquer instante sem apagar o progresso narrativo).*
- **Velocidade do Texto:** Ajuste do efeito de digitação (*typewriter*) de lento a instantâneo.
- **Confirmação de Ações Críticas:** Alerta de confirmação antes de submeter sentenças finais em tribunais.

### D. Dados e Privacidade
- **Salvamento Automático e Manual:** 3 slots locais disponíveis com backup atômico de segurança.
- **Reset Seguro de Dados:** Botão de exclusão total protegido por confirmação deliberada (segurar por 3 segundos e digitar "CONFIRMAR") para evitar perdas acidentais.
