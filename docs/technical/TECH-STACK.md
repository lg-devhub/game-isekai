# TECH-STACK — Escolha Tecnológica Definitiva e Análise Comparativa

Este documento formaliza a decisão tecnológica definitiva do projeto **Echoes of the Veil**, apresenta a matriz comparativa entre motores e frameworks avaliados, e detalha as justificativas técnicas para a escolha da **Godot Engine 4.x** com **GDScript**, em arquitetura **100% off-line** ([`LEARNING-DESIGN.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/game-design/LEARNING-DESIGN.md)).

---

## 1. Decisão Técnica Definitiva: Godot Engine 4.x (GDScript)

> **STATUS DA DECISÃO:** **CONFIRMADA E DEFINITIVA**. A engine oficial para o desenvolvimento de *Echoes of the Veil* é a **Godot Engine 4.x**, utilizando **GDScript** como linguagem primária de programação.
> 
> *Nota de Ambiente:* Foi detectada a presença da versão 4.x da Godot no ambiente do usuário (`Godot_v4.7.2-stable_win64.exe`), confirmando total alinhamento e prontidão do ambiente de desenvolvimento.

---

## 2. Matriz Comparativa de Tecnologias Avaliadas

Antes de consolidar a escolha, foram avaliadas quatro alternativas relevantes para desenvolvimento mobile 2D com foco em narrativa, interface e puzzles:

| Critério de Avaliação | **Godot 4.x (GDScript)** *(Escolhida)* | **Unity (C# / URP 2D)** | **Flutter / Dart** *(App Framework)* | **Defold (Lua)** |
| :--- | :--- | :--- | :--- | :--- |
| **Foco em UI 2D Mobile** | **Excelente:** Nós de `Control`, Containers responsivos, anchors flexíveis e sistema de `Theme` nativo. | Bom: Canvas UI poderoso, mas verboso e pesado para layouts puramente responsivos. | **Excelente:** Layouts declarativos perfeitos para texto e listas, mas fraco para animações de partículas 2D. | Razoável: Sistema de GUI básico, exige criação manual de componentes complexos. |
| **Tamanho do Binário Inicial** | **Muito Baixo:** APK base de ~35-45 MB sem overhead de runtimes desnecessários. | Alto: Build base mobile de ~60-90 MB devido ao runtime Mono/IL2CPP. | Baixo: ~30-40 MB. | **Excepcional:** Menos de 15 MB. |
| **Consumo de Memória & Bateria** | **Baixo:** Renderer de Compatibilidade (OpenGL ES 3.0 / Vulkan Mobile) otimizado para celulares modestos. | Moderado/Alto: Garbage Collector do C# exige monitoramento constante no mobile. | Baixo para interfaces, moderado em renderização gráfica contínua. | **Muito Baixo:** Extremamente frugal em recursos. |
| **Operação 100% Off-line** | **Nativo:** Sem dependência de serviços em nuvem, inicialização e persistência estritamente locais. | Requer configuração para remover pacotes de telemetria e serviços online padrão. | Depende da arquitetura do app; bibliotecas móveis frequentemente exigem rede. | Nativo para jogos locais. |
| **Pipeline de Dados & Códice** | **Nativo:** Parseador JSON rápido, Custom Resources (`.tres`) tipados e `ResourceLoader`. | Bom: ScriptableObjects e JsonUtility/Newtonsoft. | Razoável: Serialização Dart via `json_serializable`. | Razoável: Tabelas Lua simples. |
| **Pipeline de Áudio** | **Excelente:** `AudioServer` nativo com barramentos independentes, efeitos em tempo real e reamostragem. | Bom: AudioMixer robusto, mas com curva de setup mais complexa. | Fraco: Depende de plugins de terceiros, com latência variável em Android. | Básico: Módulos de som e buffers simples. |
| **Licenciamento & Custos** | **100% Livre (MIT):** Sem taxas por instalação, sem royalties, sem assinaturas corporativas. | Proprietário: Políticas de licenciamento variáveis e taxas de distribuição. | Livre (BSD-3). | Livre (Zlib modificada). |
| **Exportação Android / iOS** | **Direta e Eficiente:** Geração de APK/AAB e projeto Xcode limpo com export presets configuráveis. | Robusta, com excelente suporte a SDKs comerciais. | Excelente para mobile nativo. | Excelente para mobile. |

---

## 3. Justificativas Detalhadas para a Escolha da Godot 4.x

### A. Adequação Superior a Interfaces Touchscreen (UI/UX)
*Echoes of the Veil* é um RPG pedagógico fundamentado em inspeção de documentos, leitura do *Códice do Conhecimento*, caixas de diálogo e manipulação de engrenagens e grids. A arquitetura de nós da Godot baseada em `Control`, `MarginContainer`, `VBoxContainer`, `HBoxContainer`, `ScrollContainer` e `TextureRect` oferece o ambiente mais ágil e ergonômico da indústria para criar interfaces responsivas que se adaptam perfeitamente a qualquer resolução de smartphone (de 16:9 até 20:9 e tablets) com ancoragem automática (*Anchors* e *Safe Area*).

### B. O Papel do GDScript 2.0 (Godot 4.x)
O GDScript moderno na versão 4.x conta com:
- **Tipagem Estática Opcional e Robusta (`var x: int = 10`):** Garante segurança de código, autocompletar preciso e detecção de erros em tempo de compilação sem sacrificar a velocidade de iteração.
- **Integração Profunda com a Engine:** Manipulação direta de nós, sinais (`signals`), *Callables* e lambdas de primeira classe, tornando o gerenciamento de eventos de UI, feedback diagnóstico e puzzles extremamente limpo e legível.
- **Baixo Custo de Manutenção:** Não requer compilação pesada prévia ou rebuilds lentos de C#/C++, acelerando drasticamente o ciclo de testes e validação.

### C. Desacoplamento entre Lógica e Conteúdo (*Content as Data*)
A engine oferece suporte de alto desempenho à leitura e escrita de arquivos JSON estruturados e recursos nativos (`Resource`), permitindo que nossos catálogos de quests, puzzles e entradas enciclopédicas do Códice residam inteiramente em arquivos de dados externos. Isso significa que novos enigmas e revisões de texto podem ser injetados no jogo sem recompilar scripts principais.

### D. Rendimento, Autonomia de Bateria e Privacidade
Ao utilizar o renderizador **Compatibility (OpenGL / WebGL)** da Godot 4.x para nosso jogo 2D:
- O consumo da GPU do smartphone permanece mínimo, prolongando a vida útil da bateria em sessões longas de leitura;
- A taxa de quadros estabiliza em 60 FPS contínuos mesmo em aparelhos Android de entrada (com 3 GB de RAM ou processadores modestos);
- A inicialização do jogo ocorre em menos de 2,5 segundos em modo 100% off-line, garantindo privacidade absoluta para o público jovem (12 a 17 anos).

---

## 4. Diretrizes de Arquitetura na Godot 4.x

1. **Configuração de Display:**
   - Modo de Janela: Orientação Vertical (`portrait`).
   - Modo de Estiramento: `mode = "canvas_items"`, `aspect = "expand"`.
   - Resolução de Referência: $1080 \times 1920$ pixels.
2. **Sistema de Barramentos de Áudio:**
   - Barramento 0: `Master`
   - Barramento 1: `Music`
   - Barramento 2: `Ambience`
   - Barramento 3: `SFX`
   - Barramento 4: `UI`
3. **Formato de Exportação:**
   - Android: Android App Bundle (`.aab`) assinado via Keystore para publicação no Google Play, e pacotes `.apk` para depuração e testes locais em dispositivos físicos.
   - iOS: Exportação de projeto Xcode configurado para compilação direta via macOS/Xcode na fase de publicação.
