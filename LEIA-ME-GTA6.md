# GTA VI no VIctory — build test/fx-prs

Build com **rostos e corpos, iluminação e texturas funcionando**. Testada numa RTX 5070 12 GB com Ryzen 5 5600. Roda a ~2–3 fps depois de carregar.

## O que tem nesta build
- fork fxceless (main 4e17478) + PRs #11, #9, #48 do fork;
- correção de rostos e corpos (interpolação do `PS_DeferredTextured`);
- correções do PR #9 (`makeDouble.f64` e flag de doubles), para o shader de água validar;
- releitura do DirectStorage quando uma gravação falha, para não faltar parede nem cabeça;
- lançador `jogar.ps1` já com as configurações certas.

## Como usar
1. Instale o Rust (https://rustup.rs) e o Visual Studio Build Tools (C++).
2. Baixe esta branch:
   ```
   git clone -b test/fx-prs https://github.com/asdaasdsaddf/VIctory.git
   cd VIctory
   ```
3. Compile (demora):
   ```
   cargo build --release
   ```
4. **Feche navegador, Discord, OBS e overlays.** Eles ocupam memória de vídeo, e as texturas ficam pretas.
5. Rode:
   ```
   powershell -ExecutionPolicy Bypass -File .\jogar.ps1 -Game "D:\caminho\do\jogo\game_scarlett_master.exe"
   ```
   Se você não passar `-Game`, o lançador pergunta o caminho do jogo. A log fica em `run.log`.

Na primeira vez, os pipelines são montados e os primeiros minutos ficam bem lentos. Nas próximas vezes, eles já vêm do cache. Depois de cada carregamento, as texturas vão aparecendo aos poucos.

## Não faça
- `VICTORY_DISPLAY_MODE=1920x1080`: apaga a iluminação interna.
- `VICTORY_TEXTURE_CATCHUP` ligado: o jogo cai para 0,2 fps por minutos depois de carregar. O `jogar.ps1` já desliga.
- `VICTORY_BVH_BUILDER`: o jogo trava.

## Teste de fps (opcional)
O `jogar-rapido.ps1` é igual ao `jogar.ps1`, mais estas chaves: `VICTORY_CARD_BUFFERS_MIN_MB=1`, `VICTORY_CARD_BUFFERS_MB=1024` e `VICTORY_WIDE_BACK=1`. Ainda não foi testado. Se ficar pior, volte para o `jogar.ps1`.
