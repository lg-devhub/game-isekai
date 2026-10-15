# PERFORMANCE-AND-SECURITY — Desempenho, Otimização e Proteção de Menores

Este documento estabelece as metas de desempenho técnico, as estratégias de economia de memória e bateria, e os protocolos de segurança e privacidade em estrita conformidade com as legislações de proteção de dados de crianças e adolescentes (LGPD Art. 14, GDPR-K e COPPA).

---

## 1. Metas e Orçamento de Desempenho (Performance Budget)

| Métrica Técnica | Meta em Aparelhos Intermediários | Limite Crítico Tolerado |
| :--- | :--- | :--- |
| **Taxa de Quadros (Framerate)** | 60 FPS contínuos | Não cair abaixo de 45 FPS durante transições |
| **Uso de Memória RAM** | Abaixo de 250 MB | Máximo de 350 MB em telas complexas do Códice |
| **Tamanho da Instalação (APK/AAB)** | Menos de 60 MB inicial | Menos de 100 MB com todos os assets de áudio |
| **Tempo de Inicialização (Cold Start)**| Menos de 2,5 segundos | Menos de 4 segundos em aparelhos de entrada |
| **Drenagem de Bateria** | Menos de 7% por hora de tela ativa | Menos de 12% por hora |
| **Temperatura do Dispositivo** | Aquecimento térmico imperceptível | Não provocar *thermal throttling* |

---

## 2. Estratégias de Otimização na Godot 4.x

1. **Renderizador Compatibility (OpenGL ES 3.0):**
   - Evita os custos de compilação de shaders pesados do Vulkan Mobile em aparelhos modestos, garantindo compatibilidade com quase 100% da base ativa de smartphones Android.
2. **Descarregamento Agressivo de Cenas Inativas:**
   - Cenas de puzzles complexos, visualizadores de documentos e janelas do Códice são explicitamente liberados da memória via `queue_free()` ao serem fechadas.
3. **Pausar Processamento Físico Quando Ocioso:**
   - Como *Echoes of the Veil* é um RPG narrativo com puzzles baseados em turnos/toques, o loop de física (`_physics_process`) é desativado na maioria dos nós de UI, e a taxa de atualização pode ser reduzida dinamicamente quando a tela estiver em leitura estática (`OS.low_processor_usage_mode = true`).
4. **Gerenciamento de Ciclo de Vida do Sistema Operacional (OS Lifecycle):**
   - Tratamento adequado de notificações do sistema operacional através de `MainLoop.NOTIFICATION_APPLICATION_PAUSED` e `NOTIFICATION_APPLICATION_RESUMED`:
     - Pausa imediata de áudios e salvamento automático do estado em andamento ao receber chamadas telefônicas ou alternar de aplicativo;
     - Retomada sem perdas de progresso ao reabrir o jogo.

---

## 3. Segurança de Dados e Proteção de Menores (12 a 17 Anos)

O projeto adota o princípio de **Privacidade Máxima por Padrão (*Privacy by Default*)**:

1. **Conformidade Estrita com LGPD (Art. 14), COPPA e GDPR-K:**
   - Como o público-alvo é composto por adolescentes de 12 a 17 anos, o jogo **não coleta dados pessoais**:
     - Sem cadastro de nome real, e-mail, telefone, CPF ou dados biométricos.
     - Sem coleta de geolocalização ou identificadores únicos de dispositivo (IMEI, advertising ID).
     - Sem rastreamento de comportamento, profiling ou telemetria remota.
2. **Ambiente 100% Off-line Livre de Rastreamento:**
   - O aplicativo não possui conexão com servidores em nuvem, não exibe anúncios publicitários direcionados e não utiliza bibliotecas de terceiros (*SDKs* analíticos como Firebase Analytics ou Facebook SDK).
   - O aprendizado ocorre em um ambiente digital seguro, silencioso e livre de distrações comerciais ou riscos de vazamento de dados.
3. **Permissões Mínimas no Manifesto Android (`AndroidManifest.xml`):**
   - O aplicativo solicita estritamente a permissão de vibração (`android.permission.VIBRATE`) para feedback háptico nos botões.
   - Não são solicitadas permissões de câmera, microfone, contatos, localização ou acesso a arquivos externos compartilhados.
4. **Isolamento de Armazenamento Local:**
   - Todos os arquivos de saves, histórico de desafios e configurações residem no diretório privado e isolado do aplicativo (`user://`), protegido pela sandbox de segurança do sistema operacional.
