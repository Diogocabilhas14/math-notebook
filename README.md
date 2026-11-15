# MathNotebook (iPadOS)

Caderno de anotações digital com suporte nativo a Apple Pencil (PencilKit), reconhecimento de fórmulas matemáticas e resolução automática on-device.

## Estrutura do Projeto
- `MathNotebook/`: Código-fonte em SwiftUI + VisionKit + JavaScriptCore.
- `MathNotebook.xcodeproj`: Projeto configurado para compilar no iOS 16+.
- `.github/workflows/build-ipa.yml`: Workflow pronto para compilar o arquivo `.ipa` em runners macOS gratuitos do GitHub Actions.

## Como gerar o `.ipa` pelo GitHub Actions:
1. Crie um repositório no seu GitHub (ex: `math-notebook`).
2. No seu terminal dentro desta pasta:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/<seu-usuario>/math-notebook.git
   git push -u origin main
   ```
3. Acesse o seu repositório no GitHub e vá até a aba **Actions**.
4. O build iniciará automaticamente no runner macOS.
5. Quando finalizar (cerca de 2 minutos), clique na execução concluída e baixe o artefato **`MathNotebook-IPA`** (que contém o `MathNotebook.ipa`).

## Instalação via AltServer / AltStore:
1. Transfira o `MathNotebook.ipa` para o iPad (via iCloud Drive, AirDrop ou Baixando pelo Safari).
2. Abra o **AltStore** no iPad.
3. Vá na aba **My Apps**, toque no ícone `+` no canto superior esquerdo e selecione `MathNotebook.ipa`.
4. O AltServer assinará com seu Apple ID e instalará no iPad.
